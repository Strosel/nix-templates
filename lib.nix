{ pkgs }:
let
  latex = import ./lib/latex.nix { inherit pkgs; };
in
{
  lib = {
    inherit latex;
  };
}


