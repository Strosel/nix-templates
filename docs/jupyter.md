# jupyter
`jupyter` contains helper functions for Jupyter notebooks and JupyterlLb.

## `mkJupyter :: attrs -> devShell`
A `pkgs.mkShell` shorthand for Jupyter notebooks and JupyterLab.

Input: 
```nix
{ 
    # name of the derivation/devShell
    name ? "jupyter", 
    # Which python version to use
    # supported values are "python310" and "python311"
    python ? "python310", 
    # pip packages to include 
    # uses the same format as pkgs.python310Packages.withPackages
    withPackages ? ps: [ ], 
    # whether or not to use JupyterLab or notebook 
    # if false, the traditional jupyter notebook interface will be use
    lab ? false 
}
```
