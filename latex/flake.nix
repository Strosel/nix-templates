{
  description = "Nix enironment for latex documents using latexmk and lualatex";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    strosel-utils.url = "github:strosel/nix-templates";
  };

  outputs = { self, nixpkgs, flake-utils, strosel-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-minimal latex-bin latexmk tools babel-swedish
            # Add tex deps here
            ;
        };

        strosel = import strosel-utils { inherit pkgs; };
        doc = strosel.lib.latex.mkLatexProject {
          name = "latex-demo-document";
          latexInputs = tex;
        };
      in
      {
        packages.default = doc.build;
        apps.default = doc.watch;
      });
}
