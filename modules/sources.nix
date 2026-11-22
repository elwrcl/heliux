{
  versions = {
    linux = "0.22.2.1";
    darwin = "0.22.2.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-91Rrx92GAn6SSRb962JgTfybRQe8dMVyy9HFls7E0Mo=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-uo+W/tdiCmTxTXpWBgOaLvASiQ1fo7U5Ms+Gn7li2YU=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-2jWT9JEEB5e79jhUsZYmFEeWO01TDfSXRiRkiMM59bU=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-wzU6qTaERhMhAgPJR8PTFd6zJVx40JKTFBxEfdMkw4g=";
    };
  };
}
