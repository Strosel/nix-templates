{pkgs}: {
  mkJupyter = {
    name ? "jupyter",
    python,
    withPackages ? ps: [],
    lab ? false,
  }:
    pkgs.mkShell
    {
      inherit name;
      buildInputs = [
        (python.withPackages (ps:
          with ps;
            [
              pip
              (
                if lab
                then jupyterlab
                else jupyter
              )
            ]
            ++ (withPackages ps)))
      ];
      shellHook = ''
        jupyter ${
          if lab
          then "lab --LabApp.extension_manager=readonly"
          else "notebook"
        } && exit # exit nix-shell when closing jupyter
      '';
    };

  labApp = {
    name ? "jupyter-lab",
    python,
    withPackages ? ps: [],
    extraArgs ? "",
  }: let
    lab = pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [
        (pkgs.${python}.withPackages (
          ps:
            with ps;
              [pip jupyterlab]
              ++ (withPackages ps)
        ))
      ];
      text = ''
        jupyter-lab --LabApp.extension_manager=readonly ${extraArgs} .
      '';
    };
  in {
    type = "app";
    program = "${lab}/bin/${lab.name}";
  };
}
