{ common, buildFHSUserEnv }:

buildFHSUserEnv {
  name = "mlint";

  inherit (common) targetPkgs;

  runScript = with common; "${runPath}/bin/glnxa64/mlint";
}
