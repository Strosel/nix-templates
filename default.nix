{ pkgs }:
rec {

  #FIXME works for ./. ? 
  pathToStr = with builtins; nsp:
    let m = match "/nix/store/[^-]+-(.*)" "${nsp}"; in
    if m == null then nsp else (head m);

  buildLatex = { index, fonts, flags ? "" }: ''
    mkdir -p .cache/texmf-var
    env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
      ${if fonts != null then "OSFONTDIR=${fonts}/share/fonts" else ""} \
      latexmk -interaction=nonstopmode -pdf -lualatex -file-line-error ${flags} \
      ${index}.tex \
  '';

  mkLatexProject = { name, src ? ./src, latexInputs, index ? "index", fonts ? null }:
    let
      raw_src = pathToStr src;
    in
    rec
    {
      build =
        pkgs.stdenvNoCC.mkDerivation rec {
          inherit name src;
          buildInputs = [ pkgs.coreutils latexInputs ];
          phases = [ "unpackPhase" "buildPhase" "installPhase" ];
          buildPhase = ''
            export SOURCE_DATE_EPOCH=$(date +%s);
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            ${buildLatex {inherit index fonts;}}
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
          cd ${raw_src}
          # Watch
            ${buildLatex {inherit index fonts; flags='' -pvc -e "\$pdf_previewer='zathura'" '';}} || \
          # Cleanup aux and similar since apps run locally and not in nix-store
          latexmk -C ${index}.tex
          rm -r .cache
        '';
      };

      watch = {
        type = "app";
        program = "${watcher}/bin/${watcher.name}";
      };
    };
}
