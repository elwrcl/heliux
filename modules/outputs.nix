{ ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      sources = import ./sources.nix;

      version =
        if pkgs.stdenv.hostPlatform.isDarwin then sources.versions.darwin else sources.versions.linux;

      src = pkgs.fetchurl (
        (sources.srcs.${system} or (throw "Unsupported system: ${system}")) sources.versions
      );

      helium = pkgs.callPackage ./package.nix { inherit version src; };

      # same build with the proprietary Widevine CDM bundled, so DRM-protected
      # streaming works out of the box. Kept as a separate output rather than a
      # default so the plain `helium` package stays free-software only.
      helium-widevine = helium.override { enableWidevine = true; };

      app = {
        type = "app";
        program = "${helium}/bin/helium";
        meta = {
          inherit (helium.meta)
            description
            homepage
            license
            platforms
            ;
        };
      };
    in
    {
      packages = {
        default = helium;
        inherit helium;
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux { inherit helium-widevine; };

      apps = {
        default = app;
        helium = app;
      };

      devShells.default = pkgs.mkShell {
        packages = [
          helium
          pkgs.nix-update
        ];
      };

      formatter = pkgs.nixfmt-tree;

      checks = {
        build = helium;
      };
    };

}
