let
  pkgs = import <nixpkgs> { };
  common = import ./common.nix { };
  matlab-shell = pkgs.buildFHSUserEnv {
    name = "matlab-shell";
    inherit (common) targetPkgs;
    runScript = "bash";
  };
in pkgs.mkShell {
  buildInputs = [ matlab-shell ];
}
