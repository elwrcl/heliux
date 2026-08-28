#!/usr/bin/env bash

set -euo pipefail

if [ $# -eq 0 ]; then
    cat >&2 <<'USAGE'
Usage: prefetch-nix <ID> [<ID> ...]

Example: prefetch-nix nngceckbapebfimnlniiiahkandclblb

Environment (defaults follow programs.helium and the host platform):
  HELIUM_PRODVERSION  Chrome version advertised to the Web Store
  HELIUM_OS           "linux" or "mac"
  HELIUM_ARCH         "x64" or "arm64"
  HELIUM_OS_ARCH      uname machine name, e.g. "x86_64" / "aarch64" / "arm64"
  HELIUM_NACL_ARCH    "x86-64" or "arm"
USAGE
    exit 1
fi
case "$(uname -s)" in
    Darwin) default_os="mac" ;;
    *) default_os="linux" ;;
esac

case "$(uname -m)" in
    arm64 | aarch64)
        default_arch="arm64"
        default_nacl_arch="arm"
        if [ "$default_os" = "mac" ]; then
            default_os_arch="arm64"
        else
            default_os_arch="aarch64"
        fi
        ;;
    *)
        default_arch="x64"
        default_nacl_arch="x86-64"
        default_os_arch="x86_64"
        ;;
esac

prodversion="${HELIUM_PRODVERSION:-151.0.0.0}"
os="${HELIUM_OS:-$default_os}"
arch="${HELIUM_ARCH:-$default_arch}"
os_arch="${HELIUM_OS_ARCH:-$default_os_arch}"
nacl_arch="${HELIUM_NACL_ARCH:-$default_nacl_arch}"

UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/${prodversion} Safari/537.36"

echo "# prodversion=$prodversion os=$os arch=$arch os_arch=$os_arch" >&2

# print opening for easy copy-pasting
echo "extensions = ["

status=0

for id in "$@"; do
    url="https://clients2.google.com/service/update2/crx?response=redirect&os=${os}&arch=${arch}&os_arch=${os_arch}&nacl_arch=${nacl_arch}&prod=chromiumcrx&prodchannel=stable&prodversion=${prodversion}&acceptformat=crx3&x=id%3D${id}%26installsource%3Dondemand%26uc"

    tmpfile=$(mktemp)

    if curl -fsSL -A "$UA" "$url" -o "$tmpfile"; then
        if [ "$(head -c 4 "$tmpfile")" = "Cr24" ]; then
            hash=$(nix hash file --type sha256 --sri "$tmpfile")
            echo "  { id = \"$id\"; hash = \"$hash\"; }"
        else
            echo "  # FAILED: $id — the store returned no CRX (try raising HELIUM_PRODVERSION)."
            status=1
        fi
    else
        echo "  # FAILED: Could not reach Google Update servers for ID $id."
        status=1
    fi

    rm -f "$tmpfile"
    # sleep to avoid rate limiting if fetching many at once
    sleep 0.5
done

echo "];"

exit "$status"
