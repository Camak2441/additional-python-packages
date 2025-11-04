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
      let 
        pkgs = nixpkgs.legacyPackages.${system};
      in
      pkgs.lib.genAttrs 
      (
        (pkgs.lib.attrsets.mapAttrsToList (name: _: name) (builtins.readDir ./python-modules))
      )
      (
        package:
        import ./python-modules/${package} { pkgs = nixpkgs.legacyPackages.${system}; }
      )
    );
  };
}