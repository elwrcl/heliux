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

Helium is compiled with ***Widevine*** support, but upstream ships no CDM library and
the wrapper passes `--disable-component-update`, so the component updater can
never fetch one at runtime. The result is that DRM playback silently fails.

The `helium-widevine` package bundles the CDM next to the binary, which fixes
playback without re-enabling the update machinery:

```nix
programs.helium.package = helium.packages.${system}.helium-widevine;
```

The CDM is proprietary, so this output requires `allowUnfree`. Plain `helium` is
unchanged and stays free-software only.

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
| `extraFlags`     | list of strings    | `[]`                   | Command line arguments passed to the wrapper.      |
| `extraPolicies`  | attribute set      | `{}`                   | Raw Chromium policies to apply.                    |
| `preferences`    | attribute set      | `{}`                   | Json that will be merged into XDG Config.          |
| `defaultBrowser` | boolean            | `false`                | Set Helium as the default browser in XDG mimeapps. |

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

> [!WARNING]
> Be wary that if you are rate-limited that the file will be empty and the build will fail

Use the provided binary `prefetch-nix-extension` to obtain the nix code you need.

You can copy the IDs from the URL in the chrome web store:

```ascii
https://chromewebstore.google.com/detail/bitwarden-password-manage/nngceckbapebfimnlniiiahkandclblb
                                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ THIS PART
```

Example Usage:

```console
./prefetch-nix-extension.sh nngceckbapebfimnlniiiahkandclblb cjpalhdlnbpafiamejdnhcphjbkeiagm

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
