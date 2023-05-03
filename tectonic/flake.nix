{
  description = "Nix enironment for latex documents using tectonic";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.starship
            pkgs.tectonic
            pkgs.zathura
          ];

          shellHook = ''
            alias new="tectonic -X new"
            alias build="tectonic -X build --keep-intermediates"
            watch() {
              # see if project exists
              [[ ! -f Tectonic.toml ]] && { echo "No tectonic project found. Try `new`."; return -1; }

              # find name from input
              [[ $# = 1 ]] && name=$1 || name="default"
              local path="build/$name/$name.pdf"

              # see if compiled, else compile now
              [[ ! -f $path ]] && { build; }

              # make sure to kill both view and watch with ctrl-c
              (trap 'kill 0' SIGINT;

                # open file
                zathura $path & 

                # start watch
                tectonic -X watch -x build )
            }

            eval "$(starship init bash)"
          '';
        };
      });
}
