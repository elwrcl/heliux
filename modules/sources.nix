{
  versions = {
    linux = "0.15.7.1";
    darwin = "0.15.7.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-MQKJLN69/g1R46Y44ADo1UvKAXxS2vKsq/XlAwBO+58=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-CYHUDYEMwe+2//4cDPMS2VqcRfbRJD0USDxDJ7kKu6Q=";
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
