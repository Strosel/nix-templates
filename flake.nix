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
        latex = {
          path = ./latex;
          description = "Nix enironment for latex documents";
        };
      };

      defaultTemplate = self.templates.shell;
    };
}
