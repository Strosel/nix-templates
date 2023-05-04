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
        tex_src = "src";
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-minimal latex-bin latexmk tools babel-swedish
            # Add tex deps here
            ;
        };
      in
      rec {
        # https://flyx.org/nix-flakes-latex/
        packages.default = pkgs.stdenvNoCC.mkDerivation rec {
          name = "latex-demo-document";
          src = ./.;
          buildInputs = [ pkgs.coreutils tex ];
          phases = [ "unpackPhase" "buildPhase" "installPhase" ];
          buildPhase = ''
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            mkdir -p .cache/texmf-var
            env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              latexmk -interaction=nonstopmode -pdf -lualatex -file-line-error \
              ${tex_src}/index.tex
          '';
          installPhase = ''
            mkdir -p $out
            cp ${tex_src}/index.pdf $out/
          '';
        };

        packages.watcher = pkgs.writeShellApplication {
          name = "watch-latex-demo-document";
          runtimeInputs = [ pkgs.coreutils tex pkgs.zathura ];
          text = ''
            # Watch
            latexmk -interaction=nonstopmode -pdf -lualatex -file-line-error -pvc \
              ${tex_src}/index.tex

            # Cleanup aux and similar since apps run locally and not in nix-store
            latexmk -C ${tex_src}/index.tex
          '';
        };

        apps.default = {
          type = "app";
          program = "${packages.watcher}/bin/${packages.watcher.name}";
        };
      });
}
