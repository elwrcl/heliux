{
  versions = {
    linux = "0.22.4.1";
    darwin = "0.22.4.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-AND9I5MVVJ6RJTzySVsCGkA8z5iXenkldCsCDAV3vSw=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-UaEhjtgYWD4X2KZ/KWD+cpxtDsA30b75FKePj/sP/1c=";
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
