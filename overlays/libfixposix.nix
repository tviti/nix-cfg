self: super:

let pkg-dir = ../pkgs;
in {
  libfixposix = if super.stdenv.isDarwin then
    super.callPackage (pkg-dir + "/libfixposix") { }
  else
    super.libfixposix;
}
