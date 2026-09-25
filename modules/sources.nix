{
  versions = {
    linux = "0.18.1.1";
    darwin = "0.18.1.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-n001I57qGLKQhGIhh0JlrCqGN63/lU32n973fWsVBCw=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-UJ6kv8YX//RW9FhIFIlMbacbP+W20JY3sItPPHar7J4=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-bjWOsCgopWjfcNLNE67U9vfbI4lsEXh6wbnGIbxdbjQ=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-QY5zOYBxYcvaxC26cFIGeZcFdtUPWqTzCj8IYv60odk=";
    };
  };
}
