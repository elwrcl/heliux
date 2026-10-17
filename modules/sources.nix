{
  versions = {
    linux = "0.19.4.1";
    darwin = "0.19.4.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-bKbkoA/vWRaCH7GvipYHzGs4b2eKfrQi5V8ZEWujBGk=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-YxN2dEKeL5S7A7ZbJU3grz9kQKlepgZ6TXwM1jrJz5Y=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-ekmZ6zfoeSBZpLiqJv/8eWLIiy8xo07i4x/24hEm510=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-Ew5DEAjyXe2dUiEL36hmsKzlnQTNqv8Hx3kx+9f5MyE=";
    };
  };
}
