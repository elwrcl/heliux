{
  versions = {
    linux = "0.21.2.1";
    darwin = "0.21.2.1";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-5VwlPggvePta4JTKRlpZ4GiC/XyH6/ODFlvrNWDgtRk=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-cguQtVwZDCUGnSRD8SGgw8T+5wVWQGDXuNPyGaqeHvA=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-re44nDAupBRLKhx/1hMGhgCo+NWsXe9kew3YWPEiiAE=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-6OuyKs3TUApFe2lonEjFhkE5c9Fyyc+j3ypfin43OEQ=";
    };
  };
}
