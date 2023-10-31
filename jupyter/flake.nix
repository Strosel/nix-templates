{
  description = "Nix enironment for jupyter notebooks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = "python311";
        pythonPackages = python + "Packages";
      in
      {
        devShells.default = pkgs.mkShell {
          name = "jupyter-notebook";
          buildInputs = [
            pkgs.${pythonPackages}.jupyter
            # Add non-python deps here
            (pkgs.${python}.withPackages (ps: with ps; [
              # Add python deps here
              pip
            ]))
          ];
          shellHook = ''
            jupyter notebook && exit # exit nix-shell when closing notebook
          '';
        };
      });
}
