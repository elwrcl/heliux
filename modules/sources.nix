{
  versions = {
    linux = "0.18.2.1";
    darwin = "0.18.2.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-RJPXVrmK++P9fUXA7CFcI/WgVR+ucVWG/mzjsimLFVw=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-2EVqgJIHVwPnn/4yHlXMl57osZ8ncJzxZY7Jwthrfyk=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-kw+afHxkyGCXaKyWC5vn2btt6GrTUe1n4ZGMSwL9/KE=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-hpgtjfNA1aG/Ggx2raM9fSZ5fGw0JKRK+mdhWbaj4+s=";
    };
  };
}
