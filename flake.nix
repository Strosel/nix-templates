{
  description = "A collection of nix flake templates";

  outputs = { self }:
    {
      templates = {
        shell = {
          path = ./shell;
          description = "A basic dev shell";
        };
        jupyter = {
          path = ./jupyter;
          description = "Nix enironment for jupyter notebooks";
        };
        tectonic = {
          path = ./tectonic;
          description = "Nix enironment for latex documents using tectonic";
        };
        latex = {
          path = ./latex;
          description = "Nix enironment for latex documents using latexmk and lualatex";
        };

        default = self.templates.shell;
      };
    };
}
