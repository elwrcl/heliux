{
  versions = {
    linux = "0.21.1.1";
    darwin = "0.21.1.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-bNfyQBU8ucDN+ie/GmZR3crnOomK/ESak90Q2oO0vUU=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-Zyo+nVge36QUSS6hJlKqvfAucAuOieK1WZQZxw0B3EQ=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-XqdXWN9L8up/rtwd45vABufioOPJJYkEMQ+D4wEPAbA=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-4L441LObjOEgt8fu2hKOz7oOZhHV0j8vurLjUQwnYzE=";
    };
  };
}
