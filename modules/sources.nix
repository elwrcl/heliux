{
  versions = {
    linux = "0.21.3.1";
    darwin = "0.21.3.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-iPPFOiNxguhyrDBhzIwSnnWuy86Erq2DQiXYEDCWwlQ=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-shm+E3Rbq0/H9wBqlSTPZ/mfw2zS5vlFIRejn+6G1Ak=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-r2mu6/rLpR9Z9n5Y/YnFGhDitjKtucf+Wab7/P+WNSs=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-PevQ8vOjzw9L+l375NgHozkcF8dSF4vkRJcZJF7QYQs=";
    };
  };
}
