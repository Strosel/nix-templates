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
      };

      defaultTemplate = self.templates.shell;
    };
}
