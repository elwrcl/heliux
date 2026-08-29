{
  versions = {
    linux = "0.16.2.1";
    darwin = "0.16.2.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-gAg4BpJyhwpvT8nq3wF8CBn32Jq/YHEXCAsHnUv3wBc=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-7l33oPwHvlGrokwNq57T57eUcZkTevjZ0mqfWPfTjfc=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-6B5emXANnV4d1+rIdyTxSKOyXfxs4WocT+pwJ2xowFM=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-aoi566LGNGht1XhyyZCla7kl7lk0WzTq33aBMkKhyu8=";
    };
  };
}
