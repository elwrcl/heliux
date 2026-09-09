{
  versions = {
    linux = "0.16.6.1";
    darwin = "0.16.6.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-EAN0S0/5d5fH090S2ov3QnjF9Ok+kfFbQRtXr8/8LzE=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-geKUvsOEoU1ZUdkopxHTwdbiD1rNq4RKQ8kqxMsfvRs=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-3354/AE7pPl8AnlMqTuJZ+YJfAYIi0c/9frde/Jm3qs=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-N3tVzdYFTIyzxr6aG2sAjYyTYrXvhKoenc+JPvfL5Lg=";
    };
  };
}
