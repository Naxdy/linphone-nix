{
  description = "Linphone packages";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # Stable Nixpkgs

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Flake outputs
  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
    }:
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
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };

            treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

            treefmt = treefmtEval.config.build.wrapper;
          in
          f {
            inherit
              pkgs
              treefmt
              treefmtEval
              ;
          }
        );
    in
    {
      formatter = forEachSupportedSystem ({ treefmt, ... }: treefmt);

      devShells = forEachSupportedSystem (
        { pkgs, treefmt, ... }:
        {
          default = pkgs.mkShell {
            packages = [ treefmt ];
          };
        }
      );

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
            liblinphone
            bc-ispell
            linphone-desktop
            ;
        }
      );

      overlays.default = final: prev: {
        linphonePackages = final.callPackage ./packages/linphone-packages.nix { };
      };

      checks = forEachSupportedSystem (
        { treefmtEval, ... }:
        {
          treefmt = treefmtEval.config.build.check self;
        }
      );
    };
}
