{
  versions = {
    linux = "0.16.4.1";
    darwin = "0.16.4.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-aD7bp0q49q4KxycqPCf575RWkGKeFSU3CIexeBXO3L4=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-OX6bc9mAX7WqH9BXwZ79sUxFHftu5b+lPmMDZdk9rg4=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-FwtKzzGwI/asmn28OlLApmIo8oYPoNp1vdkeo1uo+t8=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-fJRdy6yoFR0rLCh9Q4p7Rry+aaPZ2SHbh9YMw1tLj2w=";
    };
  };
}
