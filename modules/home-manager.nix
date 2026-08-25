{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.helium;

  fetchExtension =
    { id, hash }:
    let
      os = if pkgs.stdenv.isDarwin then "mac" else "linux";
      arch = if pkgs.stdenv.isAarch64 then "arm64" else "x64";
      os_arch = if pkgs.stdenv.isDarwin then "arm64" else "x86_64";
    in
    pkgs.fetchurl {
      name = "${id}.crx";
      url = "https://clients2.google.com/service/update2/crx?response=redirect&os=${os}&arch=${arch}&os_arch=${os_arch}&nacl_arch=x86-64&prod=chromiumcrx&prodchannel=stable&prodversion=${cfg.prodversion}&acceptformat=crx3&x=id%3D${id}%26installsource%3Dondemand%26uc";
      inherit hash;
    };

  unpackExtension =
    { id, hash }:
    pkgs.runCommand "helium-ext-${id}"
      {
        nativeBuildInputs = [ pkgs.unzip ];
        src = fetchExtension { inherit id hash; };
      }
      ''
        # The Web Store answers 204 No Content for extensions that need a newer
        # browser than `prodversion` claims. fetchurl stores that empty body
        # happily, so without this check the build succeeds and the extension is
        # silently missing at runtime.
        if [ ! -s "$src" ]; then
          echo "error: the CRX for ${id} is empty." >&2
          echo "The Chrome Web Store returned no content, which usually means" >&2
          echo "programs.helium.prodversion (${cfg.prodversion}) is older than the" >&2
          echo "extension supports. Raise it and re-run the hash prefetch." >&2
          exit 1
        fi

        mkdir -p $out
        unzip -q $src -d $out || true

        # Remove the system-reserved metadata folder that causes the load error
        rm -rf $out/_metadata
      '';

  resolvedExtensions = map (spec: {
    inherit (spec) id;
    unpacked = unpackExtension { inherit (spec) id hash; };
  }) cfg.extensions;

  policyAttrs = {
    ExtensionInstallAllowlist = map (ext: ext.id) cfg.extensions;
  }
  // cfg.extraPolicies;

  extensionRoot = "${config.xdg.dataHome}/helium/extensions";
  loadExtensionFlag =
    if resolvedExtensions != [ ] then
      [
        "--load-extension=${
          lib.concatMapStringsSep "," (ext: "${extensionRoot}/${ext.id}") resolvedExtensions
        }"
      ]
    else
      [ ];

  heliumWithFlags = pkgs.symlinkJoin {
    name = "helium-configured";
    paths = [ cfg.package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/helium \
        ${lib.concatMapStringsSep " \\\n        " (f: "--add-flags ${lib.escapeShellArg f}") (
          [
            "--disable-component-update"
            "--allow-file-access-from-files"
          ]
          ++ loadExtensionFlag
          ++ lib.optionals pkgs.stdenv.isLinux [
            "--ozone-platform-hint=auto"
            "--enable-features=WaylandWindowDecorations,NativeNotifications,SystemNotifications"
          ]
          ++ cfg.extraFlags
        )}
    '';
  };

in
{
  options.programs.helium = {
    enable = lib.mkEnableOption "Helium browser";
    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.helium;
    };
    extensions = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            id = lib.mkOption { type = lib.types.str; };
            hash = lib.mkOption { type = lib.types.str; };
          };
        }
      );
      default = [ ];
    };
    prodversion = lib.mkOption {
      type = lib.types.str;
      default = "151.0.0.0";
      description = ''
        Chrome version advertised to the Web Store when downloading extensions.

        The store replies 204 No Content for any extension that requires a newer
        browser than this, and an empty body still hashes fine, so too low a
        value yields extensions that build but are empty. Keep it at or above
        the Chromium version Helium is based on.
      '';
    };
    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    extraPolicies = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };
    defaultBrowser = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    finalPolicyJson = lib.mkOption {
      type = lib.types.str;
      internal = true;
      default = builtins.toJSON policyAttrs;
    };

    preferences = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = ''
        Chromium preferences to set in the Default profile.
        These are merged into ~/.config/net.imput.helium/Default/Preferences.
        Type: 'helium://prefs-internals/' to search for the json keys and values
      '';
      example = lib.literalExpression ''
        {
          "browser"."show_home_button" = true;
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        heliumWithFlags
        pkgs.jq
        pkgs.coreutils
      ];

      activation = {
        # Refresh the writable copies the --load-extension flag points at. The
        # tree is rebuilt from scratch so extensions that were removed from the
        # config, or whose store path changed, do not linger.
        heliumExtensions = lib.mkIf (resolvedExtensions != [ ]) (
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            run rm -rf ${lib.escapeShellArg extensionRoot}
            run mkdir -p ${lib.escapeShellArg extensionRoot}
            ${lib.concatMapStringsSep "\n" (ext: ''
              run cp -r ${ext.unpacked} ${lib.escapeShellArg "${extensionRoot}/${ext.id}"}
            '') resolvedExtensions}
            run chmod -R u+w ${lib.escapeShellArg extensionRoot}
          ''
        );

        heliumPreferences = lib.mkIf (cfg.preferences != { }) (
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          prefs_dir="$HOME/.config/net.imput.helium/Default"
          prefs_file="$prefs_dir/Preferences"
          nix_prefs='${builtins.toJSON cfg.preferences}'

          run mkdir -p "$prefs_dir"

          if [ -f "$prefs_file" ]; then
            merged=$(${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$prefs_file" - <<< "$nix_prefs")
            if [ -n "$merged" ]; then
              printf '%s\n' "$merged" > "$prefs_file"
            fi
          else
            printf '%s\n' "$nix_prefs" > "$prefs_file"
          fi
        ''
        );
      };
    };

    xdg.mimeApps = lib.mkIf cfg.defaultBrowser {
      enable = true;
      defaultApplications = {
        "text/html" = "helium.desktop";
        "x-scheme-handler/http" = "helium.desktop";
        "x-scheme-handler/https" = "helium.desktop";
      };
    };
    xdg.desktopEntries.helium = lib.mkIf cfg.defaultBrowser {
      name = "Helium";
      exec = "${heliumWithFlags}/bin/helium %U";
      icon = "helium";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeType = [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };
  };
}
