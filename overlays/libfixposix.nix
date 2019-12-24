self: super:

let pkg-dir = ../pkgs;
in {
  libfixposix = if super.stdenv.isDarwin then
    super.pkgs.callPackage (pkg-dir + "/libfixposix") { }
  else
    super.pkgs.libfixposix;
}
