{
  description = "Nix enironment for jupyter notebooks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    strosel-utils.url = "github:strosel/nix-templates";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    strosel-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      strosel = import strosel-utils {inherit pkgs;};
    in {
      devShells.default = strosel.lib.jupyter.mkJupyter {
        name = "jupyter-notebook";
        python = pkgs.python3;
        withPackages = ps: with ps; [];
      };
    });
}
