{
  description = "Nix enironment for latex documents using latexmk and lualatex";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-minimal latex-bin latexmk tools babel-swedish
            # Add tex deps here
            titlesec titling tcolorbox pgf environ etoolbox pdfcol
            tikzfill ltxcmds infwarerr amsmath listings enumitem
            fancyhdr float caption geometry fontspec epstopdf-pkg;
        };
      in
      rec {
        # https://flyx.org/nix-flakes-latex/
        packages.default = pkgs.stdenvNoCC.mkDerivation rec {
          name = "latex-demo-document";
          src = self;
          buildInputs = [ pkgs.coreutils tex ];
          phases = [ "unpackPhase" "buildPhase" "installPhase" ];
          buildPhase = ''
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            mkdir -p .cache/texmf-var
            env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              latexmk -interaction=nonstopmode -pdf -lualatex -file-line-error \
              src/index.tex
          '';
          installPhase = ''
            mkdir -p $out
            cp src/index.pdf $out/
          '';
        };

        packages.watcher = pkgs.writeShellApplication {
          name = "watch-latex-demo-document";
          runtimeInputs = [ pkgs.coreutils tex pkgs.zathura ];
          text = ''
            # Watch
            latexmk -interaction=nonstopmode -pdf -lualatex -file-line-error -pvc \
              src/index.tex

            # Cleanup aux and similar since apps run locally and not in nix-store
            latexmk -C src/index.tex
          '';
        };

        apps.default = {
          type = "app";
          program = "${packages.watcher}/bin/${packages.watcher.name}";
        };
      });
}
