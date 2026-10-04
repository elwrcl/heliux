{
  versions = {
    linux = "0.18.3.1";
    darwin = "0.18.3.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-ib2WLKXlFZkWpMS++lqaCPVA0tjNeU8vlV6NXUpGO/I=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-S3t0TlXEAnL7NLFIrq1+NrjY0I0EQTH0Vy9PqV0U7JI=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-2IYVl+aQFRnWipccdYeCSPDcc7/vkS9NRmiHLV0NfJ0=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-Sdyl7kdt+FKNiMfREcgi8OtKHA5IdQLqzUhkd+p3qgU=";
    };
  };
}
