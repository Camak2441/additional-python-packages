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
  in rec {
    packages = forAllSystems (
      system:
      let 
        pkgs = import nixpkgs { 
          inherit system; 
          config.allowUnfree = true; 
          config.cudaSupport = true;
        };
      in
      pkgs.lib.genAttrs 
      (
        (pkgs.lib.attrsets.mapAttrsToList (name: _: name) (builtins.readDir ./python-modules))
      )
      (
        package:
        import ./python-modules/${package} { inherit pkgs inputs; }
      )
    );

    devShells = forAllSystems (
      system:
      let
        pkgs = import nixpkgs { 
          inherit system; 
          config.allowUnfree = true; 
          config.cudaSupport = true;
        };
        addPyPkgs = self.packages.${system};
      in
      {
        default = pkgs.mkShell rec {
          packages = with pkgs; [
            (python3.withPackages (ps: builtins.attrValues addPyPkgs))
          ];

          shellHook = ''
            echo "Successfully built all additional python packages"
          '';
        };
      }
    );
  };
}