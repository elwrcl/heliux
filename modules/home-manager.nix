{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.helium;
  webStorePlatform =
    let
      inherit (pkgs.stdenv.hostPlatform) isDarwin isAarch64;
    in
    {
      os = if isDarwin then "mac" else "linux";
      arch = if isAarch64 then "arm64" else "x64";
      os_arch =
        if !isAarch64 then
          "x86_64"
        else if isDarwin then
          "arm64"
        else
          "aarch64";
      nacl_arch = if isAarch64 then "arm" else "x86-64";
    };

  # Shared by fetchExtension and the prefetch-nix wrapper, so a hash obtained by
  # hand is always a hash for the CRX the module will go on to download.
  crxUrl =
    id:
    "https://clients2.google.com/service/update2/crx"
    + "?response=redirect"
    + "&os=${webStorePlatform.os}"
    + "&arch=${webStorePlatform.arch}"
    + "&os_arch=${webStorePlatform.os_arch}"
    + "&nacl_arch=${webStorePlatform.nacl_arch}"
    + "&prod=chromiumcrx&prodchannel=stable"
    + "&prodversion=${cfg.prodversion}"
    + "&acceptformat=crx3"
    + "&x=id%3D${id}%26installsource%3Dondemand%26uc";

  fetchExtension =
    { id, hash }:
    pkgs.fetchurl {
      name = "${id}.crx";
      url = crxUrl id;
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
        if [ ! -s "$src" ]; then
          echo "error: the CRX for ${id} is empty." >&2
          echo "The Chrome Web Store returned no content, which usually means" >&2
          echo "programs.helium.prodversion (${cfg.prodversion}) is older than the" >&2
          echo "extension supports. Raise it and re-run the hash prefetch." >&2
          exit 1
        fi

        if [ "$(head -c 4 "$src")" != "Cr24" ]; then
          echo "error: the CRX for ${id} is not a CRX3 file." >&2
          echo "The Chrome Web Store served something else — an error or rate" >&2
          echo "limit page, most likely. Re-run the hash prefetch." >&2
          exit 1
        fi

        mkdir -p $out
        unzip -q $src -d $out || [ "$?" -le 1 ]

        # Remove the system-reserved metadata folder that causes the load error
        rm -rf $out/_metadata

        if [ ! -f "$out/manifest.json" ]; then
          echo "error: the CRX for ${id} unpacked without a manifest.json." >&2
          exit 1
        fi
      '';

  unpackedMode = cfg.extensionInstallMode == "unpacked";

  resolvedExtensions = lib.optionals unpackedMode (
    map (spec: {
      inherit (spec) id;
      unpacked = unpackExtension { inherit (spec) id hash; };
    }) cfg.extensions
  );

  webStoreUpdateUrl = "https://clients2.google.com/service/update2/crx?prodversion=${cfg.prodversion}";

  policyAttrs = {
    ExtensionInstallAllowlist = map (ext: ext.id) cfg.extensions;
  }
  // lib.optionalAttrs (!unpackedMode && cfg.extensions != [ ]) {
    ExtensionInstallForcelist = map (ext: "${ext.id};${webStoreUpdateUrl}") cfg.extensions;
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

  enabledFeatures = lib.unique (
    (cfg.package.enabledFeatures or [ ])
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      "NativeNotifications"
      "SystemNotifications"
    ]
    ++ cfg.extraFeatures
  );

  heliumWithFlags = pkgs.symlinkJoin {
    name = "helium-configured";
    paths = [ cfg.package ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/helium \
        ${lib.concatMapStringsSep " \\\n        " (f: "--add-flags ${lib.escapeShellArg f}") (
          [
            "--disable-component-update"
          ]
          ++ lib.optional cfg.allowFileAccessFromFiles "--allow-file-access-from-files"
          ++ loadExtensionFlag
          ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            "--ozone-platform-hint=auto"
          ]
          ++ lib.optional (
            enabledFeatures != [ ]
          ) "--enable-features=${lib.concatStringsSep "," enabledFeatures}"
          ++ cfg.extraFlags
        )}

      if [ -e $out/bin/prefetch-nix ]; then
        wrapProgram $out/bin/prefetch-nix \
          --set-default HELIUM_PRODVERSION ${lib.escapeShellArg cfg.prodversion} \
          --set-default HELIUM_OS ${lib.escapeShellArg webStorePlatform.os} \
          --set-default HELIUM_ARCH ${lib.escapeShellArg webStorePlatform.arch} \
          --set-default HELIUM_OS_ARCH ${lib.escapeShellArg webStorePlatform.os_arch} \
          --set-default HELIUM_NACL_ARCH ${lib.escapeShellArg webStorePlatform.nacl_arch}
      fi
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
            hash = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                CRX hash, only needed when extensionInstallMode is "unpacked".
              '';
            };
          };
        }
      );
      default = [ ];
    };
    extensionInstallMode = lib.mkOption {
      type = lib.types.enum [
        "policy"
        "unpacked"
      ];
      default = "policy";
      description = ''
        How `extensions` reach the browser.

        "policy" force-installs them through the ExtensionInstallForcelist
        Chromium policy. The browser downloads each extension itself, so the
        Web Store IDs and signatures are preserved (native messaging hosts
        such as KeePassXC depend on the real ID), the install is recorded in
        the profile, and extensions keep updating themselves. Requires the
        NixOS module so the policy file lands in /etc/chromium/policies.

        "unpacked" pins the CRXs in the Nix store and passes them via
        --load-extension. It is reproducible and works without the NixOS
        module, but Chromium treats command-line extensions as freshly
        installed on every start, which re-fires each extension's onInstalled
        handler (welcome tabs on every launch), and derives IDs from the load
        path unless the manifest carries a "key".
      '';
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
      description = ''
        Extra command line arguments added to the wrapper.

        Do not pass `--enable-features` here: Chromium keeps a single value per
        switch, so it would replace the feature list the wrapper builds instead
        of adding to it. Use `extraFeatures` for that.
      '';
    };
    extraFeatures = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Additional Chromium features, merged into the single `--enable-features`
        switch alongside the ones the package and this module already enable.
      '';
      example = [ "VaapiVideoDecodeLinuxGL" ];
    };
    allowFileAccessFromFiles = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Pass `--allow-file-access-from-files`.

        This drops the same-origin restriction for `file://` pages, so any local
        HTML file you open — including one you just downloaded — can read other
        files on disk and send them off. Only enable it if you specifically need
        local pages to load local resources.
      '';
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

        The merge happens once, during activation. Chromium owns this file at
        runtime and rewrites it from memory when it exits, so close the browser
        before activating or your settings are written back over. Preferences
        that Chromium protects with a MAC in Secure Preferences cannot be set
        this way at all — it notices the outside edit and resets them. Use
        `extraPolicies` for anything that has to stick.
      '';
      example = lib.literalExpression ''
        {
          "browser"."show_home_button" = true;
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = map (ext: {
      assertion = ext.hash != null;
      message = ''
        programs.helium.extensions."${ext.id}".hash is required when
        programs.helium.extensionInstallMode = "unpacked".
      '';
    }) (lib.optionals unpackedMode cfg.extensions);

    home = {
      packages = [
        heliumWithFlags
        pkgs.jq
        pkgs.coreutils
      ];

      activation = {
        heliumExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] (
          if resolvedExtensions != [ ] then
            ''
              run rm -rf ${lib.escapeShellArg extensionRoot}
              run mkdir -p ${lib.escapeShellArg extensionRoot}
              ${lib.concatMapStringsSep "\n" (ext: ''
                run cp -r ${ext.unpacked} ${lib.escapeShellArg "${extensionRoot}/${ext.id}"}
              '') resolvedExtensions}
              run chmod -R u+w ${lib.escapeShellArg extensionRoot}
            ''
          else
            ''
              run rm -rf ${lib.escapeShellArg extensionRoot}
            ''
        );

        heliumPreferences = lib.mkIf (cfg.preferences != { }) (
          lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            prefs_file="$HOME/.config/net.imput.helium/Default/Preferences"
            nix_prefs=${lib.escapeShellArg (builtins.toJSON cfg.preferences)}
            merged_prefs="$(mktemp)"

            if [ -f "$prefs_file" ]; then
              if ${lib.getExe pkgs.jq} -s '.[0] * .[1]' "$prefs_file" - \
                   <<< "$nix_prefs" > "$merged_prefs"; then
                run ${lib.getExe' pkgs.coreutils "install"} -Dm600 \
                  "$merged_prefs" "$prefs_file"
              else
                warnEcho "helium: $prefs_file is not valid JSON; leaving it alone."
              fi
            else
              printf '%s\n' "$nix_prefs" > "$merged_prefs"
              run ${lib.getExe' pkgs.coreutils "install"} -Dm600 \
                "$merged_prefs" "$prefs_file"
            fi

            rm -f "$merged_prefs"
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
