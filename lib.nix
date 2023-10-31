{ pkgs }:
let
  latex = import ./lib/latex.nix { inherit pkgs; };
  jupyter = import ./lib/jupyter.nix { inherit pkgs; };
in
{
  lib = {
    inherit latex jupyter;
  };
}

