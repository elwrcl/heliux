{
  versions = {
    linux = "0.16.1.1";
    darwin = "0.15.7.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-u1L7/oXmST24AWEtrSiJDUwd7bm7fqp1gDj17kLWZuE=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-3nV7OqGUwONcRlwbBaTvQEaM6UlPtN3CHtyG9zpbSIQ=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-vQ3CkgEQHCPDvlxW24zNVkFM42OkfHIHHgmvcehU0ic=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-QQT3dtBKQvnGi3ySsgaVeXGqKIJ/iys5fDApZnDlt5E=";
    };
  };
}
