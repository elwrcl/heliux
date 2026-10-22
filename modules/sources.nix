{
  versions = {
    linux = "0.20.1.1";
    darwin = "0.20.1.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-ICP6RM76D70+GQcch+kNYSdfCLqPW0jVjCNSFVZem1M=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-IRqV4Qlg1is3Z1GSD7uTzf8FH1v8+hNrUulw9OaWNXc=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-otXrzIfHcv/43qIaheUhZcaLoxGOYTs6kV9NHTPZX7o=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-WhFxjqIjeh5Z8shPrPIWar24B3M5kIXWzXhF1z8dc5o=";
    };
  };
}
