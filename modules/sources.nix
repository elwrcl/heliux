{
  versions = {
    linux = "0.17.1.1";
    darwin = "0.17.1.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-aG072DMwZp19qANmSMWiUVYrOWO2JNoZ1en1aN3WWTA=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-GnpbJ4x+7L6o3ws5bApZq9ovSJO6XSMG73oKsvaZExY=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-oaNrQLptF9PLivOlAggU/qnIbGAs3i9HLgjvRn9YZx4=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-WaP80DO0mo2AsjtxfQfmA5iusrl+x4xwJN+WqeAbgBQ=";
    };
  };
}
