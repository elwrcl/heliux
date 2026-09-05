{
  versions = {
    linux = "0.16.5.1";
    darwin = "0.16.5.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-9hWnc1ZjWENkCGor6T8OeboSOKhWvm3bta73PnyUqXA=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-1rZkEa02ZusLIXckRH3Rcoh6HUKw6URkbE/F/FzfnBw=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-2tm2LH1/II8bQvMr3LcNCn5PuZkiCV9ESGlooD2CMgI=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-i+05Lp/WdkZ81I1oxr+uvFaRjGGgFePZHlVBF1CVTZs=";
    };
  };
}
