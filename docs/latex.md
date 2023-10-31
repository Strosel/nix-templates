# latex 
`latex` contains helper functions for LaTeX projects.

## `prepareTruetypeFonts :: attrs -> derivation` 
A simple derivation that copies `ttf` fonts into the correct directory as expected by `mkLatexProject`

Input:
```nix
{ 
    # derivation name
    name, 
    # derivation version
    version, 
    # path to font directory 
    # all ttf fonts in the directory will be copied
    src ? ./fonts 
}
```

## `mkLatexProject :: attrs -> attrs` 
A wrapper for building LaTeX project with and without live watch.

Input:
```nix
{ 
    # derivation name
    name, 
    # LaTeX source directory
    src ? ./src, 
    # LaTeX packages used by the project
    # pkgs.texlive.combine is recomended
    latexInputs, 
    # which LaTeX compiler latexmk should use 
    # supported values are
    # - lualatex
    # - xelatex
    # - pdflatex
    compiler ? "lualatex", 
    # name of the index file without .tex extention
    index ? "index", 
    # fonts used by the documents, see prepareTruetypeFonts
    fonts ? null 
}
```

Output:
```nix
{
    # A derivation that builds the document with no live view, should be supplied to `packages` in a flake
    build,
    # A derivation that builds the document with live view, should be supplied to `apps` in a flake
    # currently uses zathura as the pdf viewer
    watch
}
```
