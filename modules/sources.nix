{
  versions = {
    linux = "0.21.1.1";
    darwin = "0.20.3.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-bNfyQBU8ucDN+ie/GmZR3crnOomK/ESak90Q2oO0vUU=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-Zyo+nVge36QUSS6hJlKqvfAucAuOieK1WZQZxw0B3EQ=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-svfSqM0GbBjl1vQtMCJ9d+eznR3F4Ub8Cwmj8iXs2t0=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-+bLzEuu6qb4J/Fml3pGRQE3ACPFQJDSm8xmvKk3MusU=";
    };
  };
}
