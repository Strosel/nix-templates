{ pkgs }:
rec {
  prepareTruetypeFonts = { name, version, src ? ./fonts }: pkgs.stdenvNoCC.mkDerivation {
    inherit name version src;
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp *.ttf $out/share/fonts/truetype/
    '';
  };

  buildLatex = { index, cache ? ".cache", compiler, fonts, flags ? "" }: ''
    env TEXMFHOME="${cache}" TEXMFVAR="${cache}/texmf-var" \
      ${if fonts != null then "OSFONTDIR=${fonts}/share/fonts" else ""} \
      latexmk -interaction=nonstopmode -pdf -${compiler} -cd -file-line-error ${flags} \
      ${index}.tex \
  '';

  mkLatexProject = { name, src ? ./src, latexInputs, compiler ? "lualatex", index ? "index", fonts ? null }:
    rec
    {
      build =
        pkgs.stdenvNoCC.mkDerivation rec {
          inherit name src;
          buildInputs = [ pkgs.coreutils latexInputs ];
          phases = [ "unpackPhase" "buildPhase" "installPhase" ];
          buildPhase = ''
            mkdir -p .cache/texmf-var
            export SOURCE_DATE_EPOCH=$(date +%s);
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            ${buildLatex {inherit index fonts compiler;}}
          '';
          installPhase = ''
            mkdir -p $out
            cp ${index}.pdf $out/
          '';
        };

      watcher = pkgs.writeShellApplication {
        name = "Watch-${name}";
        runtimeInputs = [ pkgs.coreutils latexInputs pkgs.zathura ];
        text = ''
          echo "Making auxdir..."
          auxdir=$(mktemp -d -t XXX-${name})
          mkdir -p "$auxdir/texmf-var"
          echo "Made auxdir '$auxdir'"

          # Extract relative path from nix and git
          cd "$(expr "${builtins.toString src}" : "/nix/store/[0-9a-zA-Z]*-source/$(git rev-parse --show-prefix)\(.*\)")"

          # Watch
          ${buildLatex {inherit index fonts compiler; cache="$auxdir"; flags='' -pvc -e "\$pdf_previewer='zathura'" -outdir="$auxdir"'';}}
          # Cleanup aux and similar since apps run locally and not in nix-store
          rm -r "$auxdir"
        '';
      };

      watch = {
        type = "app";
        program = "${watcher}/bin/${watcher.name}";
      };
    };
}
