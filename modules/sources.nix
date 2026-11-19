{
  versions = {
    linux = "0.22.1.1";
    darwin = "0.22.1.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-5BWJi1G/HEHWvX1EAnd2yZvzbZ4O50FsHYvw3lO26gw=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-HD34QXiRzb4x1797w9cWJUkMTRWlKuS1VqMQrqTwbp8=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-DZgrEdfUTWEvNndL49azxFH1g/8kzwCeKHv3NTFRUgI=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-jCNEgMASI8nbyejcW8W+CLjkNBQ31i2unXWUK1lPvVE=";
    };
  };
}
