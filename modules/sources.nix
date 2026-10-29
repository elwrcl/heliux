{
  versions = {
    linux = "0.20.2.1";
    darwin = "0.20.2.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-upKssn7GzaNqi5SOIVQAmq7g1jMiKtJEviXnNqFD5vo=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-x6tF6ElhqgESQErE7yvj2oLRucivYLhVVzmBIvp8vGY=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-FdmXO/wul9x2bJHORKgbRoeS3H55g0P5PHHm0UInVCI=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-LL99IeEN9GxYos9b2b+lgRXWAhkZLH3aNCS+8+kqoxk=";
    };
  };
}
