# Linphone for Nix

This repo houses a flake providing build scripts for the
[Linphone Desktop App](https://gitlab.linphone.org/BC/public/linphone-desktop) and its required libraries.

All packages re located in subdirectories under `./packages` (new directories will automatically be picked up).

Most necessary libraries are developed by Belledonne Communications and reside within the
[linphone-sdk](https://gitlab.linphone.org/BC/public/linphone-sdk) monorepo. Current stable versions link packages via
git submodules, but in the future they will all be migrated directly into the `linphone-sdk` repository.

An auxiliary function `mkLinphoneDerivation` for packages derived from the `linphone-sdk` monorepo is located at
`./packages/mk-linphone-package`.

There are also some libraries which are not directly created by BC, but contain bespoke patches. These have been
prefixed with `bc-` and are not contained within the monorepo.

## Building

Build the main application with:

```shell
nix build .#linphone-desktop
```

A binary cache exists and is configured in the `flake.nix`, so you may skip building certain libraries by making use of
it.

Alternatively, this flake also provides an overlay which you may use, to ensure all packages are built against your
system's `nixpkgs`.

## Updating

To update `linphone-sdk` libraries, first edit the version in `./packages/linphone-packages.nix` and replace the hash in
`./packages/mk-linphone-derivation/default.nix`.

Then, update the actual desktop app `linphone-desktop`, as well as any custom `bc-` libraries as needed.
