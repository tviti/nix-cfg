super: self:

let pkg-dir = ../pkgs;
in {
  globus-cli = super.callPackage (pkg-dir + "/globus-cli") { };
}
