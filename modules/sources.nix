{
  versions = {
    linux = "0.17.2.1";
    darwin = "0.17.2.2";
  };

  srcs = {
    x86_64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-x86_64_linux.tar.xz";
      hash = "sha256-KmOd9U49BfQTz7tGIqTRpoWEsx2lp6r1juPNg8fD4pk=";
    };
    aarch64-linux = versions: {
      url = "https://github.com/imputnet/helium-linux/releases/download/${versions.linux}/helium-${versions.linux}-arm64_linux.tar.xz";
      hash = "sha256-6WYpl0uIuH8pKPNndzE9aqTym4uA2Mx4Ofp+6ReG7R0=";
    };
    x86_64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_x86_64-macos.dmg";
      hash = "sha256-P38ck9Ep0WKMO56n1Ttcwz1i4CcVSskIq5STk2a5aw0=";
    };
    aarch64-darwin = versions: {
      url = "https://github.com/imputnet/helium-macos/releases/download/${versions.darwin}/helium_${versions.darwin}_arm64-macos.dmg";
      hash = "sha256-CYY5HNzCql7wLB8kjE1iTRomoO6khmBsO56zNhehCVg=";
    };
  };
}
