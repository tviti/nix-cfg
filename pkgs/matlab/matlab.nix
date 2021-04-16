{ common, writeScriptBin, buildFHSUserEnv }:

let
  matlab-wrapped = with common;
    writeScriptBin "matlab" ''
      #!/bin/sh
      # export MATLAB_JAVA=/usr/lib/openjdk
      exec ${runPath}/bin/matlab "$@"
    '';
in buildFHSUserEnv {
  name = "matlab";

  targetPkgs = pkgs: with pkgs; (common.targetPkgs pkgs) ++ [ matlab-wrapped ];

  runScript = "${matlab-wrapped}/bin/matlab";
}
