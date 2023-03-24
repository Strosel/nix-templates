{
  description = "A basic dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.starship ];

          shellHook = ''
            eval "$(starship init bash)"
          '';

          buildInputs = [
            # Add shell deps here
          ];
        };
      });
}
