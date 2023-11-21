{ pkgs }: {
  mkJupyter = { name ? "jupyter", python ? "python310", withPackages ? ps: [ ], lab ? false }:
    let
      pythonPackages = python + "Packages";
    in
    pkgs.mkShell
      {
        inherit name;
        buildInputs = [
          (if lab then
            pkgs.${pythonPackages}.jupyterlab
          else
            pkgs.${pythonPackages}.jupyter)
          pkgs.${pythonPackages}.pip
          (pkgs.${python}.withPackages withPackages)
        ];
        shellHook = ''
          jupyter ${if lab then "lab --LabApp.extension_manager=readonly" else "notebook"} && exit # exit nix-shell when closing jupyter
        '';
      };
}
