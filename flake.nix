{
  description = "Linphone packages";

  # Flake inputs
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # Stable Nixpkgs

  # Flake outputs
  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
          }
        );
    in
    {
      packages = forEachSupportedSystem (
        { pkgs, ... }:
        {
          inherit (pkgs.linphonePackages)
            bcunit
            bc-decaf
            bctoolbox
            belr
            belcard
            bzrtp
            ortp
            mediastreamer2
            msopenh264
            belle-sip
            lime
            bc-soci
            ;
        }
      );

      overlays.default = final: prev: {
        linphonePackages = final.callPackage ./packages/linphone-packages.nix { };
      };
    };
}
