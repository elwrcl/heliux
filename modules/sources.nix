{
  versions = {
    linux = "0.20.3.1";
    darwin = "0.20.3.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-N1nqTpW/TvSgpkd+PXNXaw8DkG8ugDVydb/Gysr7X6w=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-9C/oUbJuFgTHc5lGOWhAmtaJUqOhgIeX42EYmzGk6gg=";
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
