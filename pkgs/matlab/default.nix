{ callPackage }:

# TODO: Be explicit about versions in file and object names!
let
  common = import ./common.nix { };
in {
  matlab = callPackage ./matlab.nix { inherit common; };
  mlint = callPackage ./mlint.nix { inherit common; };
}
