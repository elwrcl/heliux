{
  versions = {
    linux = "0.22.5.1";
    darwin = "0.22.4.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-LVuh4DxNoGHemt8rcUuWerVbewF7N82TCA/bl8ADiIY=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-bNfoVY3piOeFFTgjldmQBmtlG9MuyZcE/U/pQTtS6MM=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-ndXmbQC3cZc3ePlebVvYkpGqOEcCGj6Hksoso9QlNVw=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-MiolsE6dgiIH54reheLyTRTxvvQjOVEeBtBAHKN5XLI=";
    };
  };
}
