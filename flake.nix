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
      };

      defaultTemplate = self.templates.shell;
    };
}
