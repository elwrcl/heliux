{
  versions = {
    linux = "0.19.3.1";
    darwin = "0.19.3.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-j04BK12SH6WSaar5xUFgq/cpTGM7Gmql7bdyWUUxRXA=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-WIPQBbvCCSsnlmpgH3FT9EZkVpOCWjh8cLsi7YOhpvE=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-BQhen6QgZdNusoEPzyjq/iI7anVZku4+iUflFH/q1r4=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-ugwwxIPubEbkj/wjmuaysIR6/etU60puoxZlBUpS0Vk=";
    };
  };
}
