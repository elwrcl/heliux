{
  versions = {
    linux = "0.17.0.1";
    darwin = "0.17.0.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-UCOINeiJYlPUrxQqMDI1QRnB5vfnd5JsRTAZXHFP8/U=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-TEHiKly+KFS8O9Rap6dLzhYIf3J/j2WtZRx7oauEtG8=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-6+dyi68cdvPc3ZRf8y4JhBSviJF7jgHNKemTQa4J+xI=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-/8HOMvHzP8rSW06a0U5NGMldGJm8Q0a53ZBYDgsWBNY=";
    };
  };
}
