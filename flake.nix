{
  description = "A nix flake for whatever python packages I needed which were not in nixpkgs.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs:
  let
    systems = [
    "x86_64-linux"
    "aarch64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (
      system:
      {
        drjit = import ./python-modules/drjit { pkgs = nixpkgs.legacyPackages.${system}; };
        mitsuba = import ./python-modules/mitsuba { pkgs = nixpkgs.legacyPackages.${system}; };
        scikit-sparse = import ./python-modules/scikit-sparse { pkgs = nixpkgs.legacyPackages.${system}; };
      }
    );
  };
}