An attempt at updating Linphone & getting it to build under Nix.

All Linphone libraries are located in subdirectories under `./packages` (new directories will automatically be picked
up).

An auxiliary function `mkLinphonePackage` for packages derived from the `linphone-sdk` monorepo is located at
`./packages/mk-linphone-package`.

Build the application with:

```shell
nix build .#linphone-desktop
```
