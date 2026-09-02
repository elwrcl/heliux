{
  versions = {
    linux = "0.16.3.1";
    darwin = "0.16.3.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-Y07fuk0C6rUEjz6PHGRMJDfBL7TM2xlggXKtG4lWy+s=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-IWL37CsqOiAlrJdWx7DXlxq/BPyFzzQ/11yfVvbmDKM=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-S8TOy8Geuo/sh8AM107bJEZZKhu4ovvgpoICDvbD9Pw=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-TMJx0TBfCJNNlQC2clJa5fn1qi7UmYbYu8YlqZvYMiA=";
    };
  };
}
