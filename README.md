# heliux

Nix flake for the [Helium browser](https://helium.computer/), with NixOS and
home-manager modules for declarative extension, policy and settings management —
plus an optional bundled Widevine CDM so DRM-protected streaming works.

> [!NOTE]
> Only `x86_64-linux` is actively tested.
>
> Also this started as a copy of [gitlab.com/ntgn/helium-flake](https://gitlab.com/ntgn/helium-flake),
> which in turn was based on [schembriaiden/helium-browser-nix-flake](https://github.com/schembriaiden/helium-browser-nix-flake).
> All credit for the original packaging work goes to them. :3

## What this adds on top of upstream

- Tracks current Helium releases, updated daily by GitHub Actions.
- An `enableWidevine` build flag and a ready-made `helium-widevine` package, so
  Netflix, HBO and other DRM sites play.

## Quick start

```sh
nix run github:elwrcl/heliux
```

## DRM / Widevine

Helium is compiled with ***Widevine*** support but upstream ships no CDM library,
and the wrapper passes `--disable-component-update`, so the component updater can
never fetch one at runtime. The result is that DRM playback silently fails.

Supplying the CDM takes two steps, and the second one is easy to miss. Helium is
built with `enable_widevine` but *without* `bundle_widevine_cdm`, so it never
looks beside its own binary for a CDM — dropping the library into the package is
not enough by itself. The only location it consults at startup is the hint file
the component updater would normally leave in the user data dir:

```
~/.config/net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm
```

So `helium-widevine` pins the CDM in the store, and the home-manager module
writes that hint file pointing at it. The update machinery stays off — the hint
file is read directly at startup and does not depend on the updater:

```nix
programs.helium.package = helium.packages.${system}.helium-widevine;
```

Switching the package back to plain `helium` removes the hint file again, but
only when it points into the Nix store; a hint left by a real component update
is not touched.

The CDM is proprietary, so this output requires `allowUnfree`. Plain `helium` is
unchanged and stays free-software only.

> [!NOTE]
> The hint file is written by the home-manager module, so `helium-widevine` on
> its own — installed with `nix profile` or `environment.systemPackages` — still
> will not play DRM. Check with `helium://components`, or from the console:
> `navigator.requestMediaKeySystemAccess('com.widevine.alpha', [{initDataTypes:['cenc'],videoCapabilities:[{contentType:'video/mp4; codecs="avc1.42E01E"'}]}])`

## NixOS + home-manager

> [!IMPORTANT]
> You need **both** modules. Policies only apply when they are written to
> `/etc/chromium/policies/managed/`, which is what the NixOS module does; the
> home-manager module handles extensions, preferences and the wrapper.

Add the flake to your inputs:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    helium.url       = "github:elwrcl/helium-flake";
  };
}
```

Then configure it:

```nix
{ config, pkgs, helium, ... }:

{
  imports = [
    # Writes policies to /etc/chromium/policies/managed/
    helium.nixosModules.helium
  ];

  home-manager.users.${YOUR_USERNAME} = {
    imports = [ helium.homeModules.helium ];

    programs.helium = {
      enable = true;
      defaultBrowser = true;

      # Bundled Widevine CDM, for DRM streaming
      package = helium.packages.${pkgs.system}.helium-widevine;

      extensions = [
        # uBlock Origin
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      ];

      # Added to the wrapper
      extraFlags = [
        "--force-dark-mode"
      ];

      # Merged into the policy file in /etc
      extraPolicies = {
        HomepageLocation = "https://start.duckduckgo.com";
        PasswordManagerEnabled = false;
        MetricsReportingEnabled = false;
      };

      # See "Preferences" below
      preferences = {
        browser.show_home_button = true;
        bookmark_bar.show_on_all_tabs = true;
      };
    };
  };
}
```

## Options Reference

The following options are available under `programs.helium`:

| Option           | Type               | Default                | Description                                        |
| :--------------- | :----------------- | :--------------------- | :------------------------------------------------- |
| `enable`         | boolean            | `false`                | Whether to enable the Helium browser module.       |
| `package`        | package            | `self.packages.helium` | The helium package to use.                         |
| `extensions`     | list of submodules | `[]`                   | Extensions to install: `{ id, hash }` (`hash` only needed in `unpacked` mode). |
| `extensionInstallMode` | `"policy"` or `"unpacked"` | `"policy"` | How extensions are installed — see below.  |
| `extraFlags`     | list of strings    | `[]`                   | Command line arguments passed to the wrapper. Do not pass `--enable-features` here — use `extraFeatures`. |
| `extraFeatures`  | list of strings    | `[]`                   | Chromium features merged into the single `--enable-features` switch. |
| `allowFileAccessFromFiles` | boolean  | `false`                | Pass `--allow-file-access-from-files`. Lets any local `file://` page read other files on disk — see below. |
| `extraPolicies`  | attribute set      | `{}`                   | Raw Chromium policies to apply.                    |
| `preferences`    | attribute set      | `{}`                   | Json that will be merged into XDG Config.          |
| `defaultBrowser` | boolean            | `false`                | Set Helium as the default browser in XDG mimeapps. |

## Flags and features

Chromium stores one value per command line switch, so a second
`--enable-features=…` silently *replaces* the first instead of adding to it.
Both the package and the home-manager wrapper need to enable features, so they
build a single combined switch: the package exposes its list as
`passthru.enabledFeatures`, and the module merges its own additions and your
`extraFeatures` into it.

That is why features go in `extraFeatures` rather than `extraFlags` — a raw
`--enable-features` in `extraFlags` would come last and wipe out everything
else.

> [!WARNING]
> `allowFileAccessFromFiles` drops the same-origin restriction for `file://`
> pages. Any local HTML file you open — including one you just downloaded — can
> then read other files on your disk and send them anywhere. It is off by
> default; only turn it on if you specifically need local pages to load local
> resources.

## Policies

Since Helium is based on Chromium, you can use any of the standard Chromium
policies in the `extraPolicies` block. You can find a full list of available
names and values at the [Chrome Enterprise Policy List](https://chromeenterprise.google/policies/).

Common useful policies:

- `BrowserSignin`: Set to `0` to disable account sign-in.
- `BookmarkBarEnabled`: Set to `true` to force the bookmark bar to show.
- `URLBlocklist`: A list of URL patterns to block.

## Preferences

These are usually what you imperatively choose in the `Settings` menu. You can
find all the json keys and values inside the helium browser by typing
`helium://prefs-internals/` and searching for the values.

> [!IMPORTANT]
> The merge happens once, at activation time. Chromium owns this file while it
> runs and rewrites it from memory on exit, so close the browser before you
> activate or your settings get written back over. Preferences that Chromium
> protects with a MAC in `Secure Preferences` cannot be set this way at all — it
> spots the outside edit and resets them. Use `extraPolicies` for anything that
> has to stick.

```nix
{
  programs.helium.preferences = {
    browser.show_home_button = false;
    bookmark_bar = {
      show_apps_shortcut = false;
      show_managed_bookmarks = false;
      show_on_all_tabs = false;
      show_tab_groups = false;
    };
    helium.browser.layout = 1;
  };
}
```

## Extension install modes

`extensionInstallMode = "policy"` (the default) force-installs every entry in
`extensions` through the `ExtensionInstallForcelist` Chromium policy. The
browser downloads and installs each extension itself, so:

- the real Web Store ID and signature are kept — native messaging hosts such as
  KeePassXC-Browser match on that ID and only work this way,
- the install is recorded in the profile, so each extension's `onInstalled`
  handler runs once instead of on every launch,
- extensions keep updating themselves.

This mode needs the NixOS module, which is what writes the policy file into
`/etc/chromium/policies/managed/`. No `hash` is required.

`extensionInstallMode = "unpacked"` pins the CRXs in the Nix store and hands
them to the browser with `--load-extension`. It is fully reproducible and needs
no NixOS module, but Chromium treats command-line extensions as freshly
installed on every start — every extension re-runs its `onInstalled` handler,
which for many extensions means a welcome tab on each launch — and it derives
the extension ID from the load path unless the manifest carries a `key`. Each
entry needs a `hash` in this mode; see below.

## Obtaining extensions

Only needed for `extensionInstallMode = "unpacked"`.

Use the `prefetch-nix` binary, which the package installs alongside the browser,
to obtain the nix code you need.

The Web Store decides which build of an extension to serve from the
`prodversion`, `os` and `arch` in the request, so a hash is only valid for the
exact URL it came from. `prefetch-nix` is wrapped by the home-manager module so
it already asks for the same URL the module will later fetch. If you run the
script straight out of the repo instead, override the defaults with
`HELIUM_PRODVERSION`, `HELIUM_OS`, `HELIUM_ARCH`, `HELIUM_OS_ARCH` and
`HELIUM_NACL_ARCH` to match your `programs.helium.prodversion` and target
platform, or the hash will not match at build time.

> [!NOTE]
> If the store rate-limits you it answers with an error page rather than a CRX.
> `prefetch-nix` checks for the CRX3 magic and reports `# FAILED` instead of
> printing a hash for it, and the build refuses such a file too — so a
> rate-limited fetch can never end up as a silently empty extension.

You can copy the IDs from the URL in the chrome web store:

```ascii
https://chromewebstore.google.com/detail/bitwarden-password-manage/nngceckbapebfimnlniiiahkandclblb
                                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ THIS PART
```

Example Usage:

```console
prefetch-nix nngceckbapebfimnlniiiahkandclblb cjpalhdlnbpafiamejdnhcphjbkeiagm

# OUTPUT:
extensions = [
  { id = "nngceckbapebfimnlniiiahkandclblb"; hash = "sha256-XOVs2Tvay8hQ13SHz+728BDu2mMyQ0JxUuUI6FZ1NaM="; }
  { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; hash = "sha256-FIbmYVj8cmXce7Vq4h7d2nOjmk4RkCnABmC4y5NDyGk="; }
];
```

## Updating Helium

The `update-helium` GitHub Actions workflow checks upstream once a day, rewrites
`modules/sources.nix` with the new version and hashes, verifies the flake still
builds, and commits the bump. You can also trigger it by hand from the Actions
tab.

Note that this keeps *the flake* current — to pull an update into your system
you still run `nix flake update helium` and rebuild.

> [!NOTE]
> GitHub disables scheduled workflows in repositories with no activity for 60
> days. If updates stop arriving, re-enable the workflow in the Actions tab.

## Flake outputs

| Output                              | Description                          |
| ----------------------------------- | ------------------------------------ |
| `packages.<system>.helium`          | Helium browser package               |
| `packages.<system>.helium-widevine` | Helium with the Widevine CDM bundled |
| `apps.<system>.helium`              | `nix run` entry point                |
| `homeModules.helium`                | home-manager module                  |
| `nixosModules.helium`               | nixos module                         |
| `devShells.<system>.default`        | Shell with Helium available          |
| `formatter.<system>`                | `nixfmt-tree` (`nix fmt`)            |
| `checks.<system>.build`             | Build check (`nix flake check`)      |
