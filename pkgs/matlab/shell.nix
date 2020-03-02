let
  pkgs = import <nixpkgs> { };
  matlab = pkgs.callPackage ./default.nix { };
in pkgs.mkShell {
  buildInputs = [ matlab ];
}
