{
  description = "changeme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;
    in
    rec {
      packages = flake-utils.lib.flattenTree {
        hponcfg = pkgs.callPackage ./pkgs/hponcfg.nix { };
        default = pkgs.stdenv.mkDerivation {
          name = "changeme";

          buildInputs = [
            packages.hponcfg
          ];

          src = ./.;

          doCheck = false;

          installPhase = ''
            install -dm755 $out
          '';
        };
      };

      apps = {
        hponcfg = flake-utils.lib.mkApp { drv = packages.hponcfg; };
      };

      defaultApp = flake-utils.lib.mkApp {
        drv = packages.default;
      };

      devShell = pkgs.mkShell {
        buildInputs = [
          packages.hponcfg
        ];
      };

      checks = {
        nixpkgs-fmt = pkgs.runCommand "check-nix-format" { } ''
          ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
          install -dm755 $out
        '';
      };
    });
}
