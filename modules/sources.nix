{
  versions = {
    linux = "0.19.2.1";
    darwin = "0.19.2.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-cHzzGeOj0qoGHKFddUh3vRi4sokghzjIKfywhzvH7Ns=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-bLAgW4tP2Oukf+o4svzTvXPlFbxWBqviqvdYalej5os=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-oDLaFmSwtarTCz0CzjHhlO9TM9OxSPM6gYJATHCn4Qk=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-wH2rnBVxz2jPhWs1xtC/IcLPU/d8QyRRYwGOeICU6/E=";
    };
  };
}
