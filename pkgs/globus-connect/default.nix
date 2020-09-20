{ stdenv, autoPatchelfHook, requireFile, makeWrapper, gnutar, libaudit, tcllib
, tk, }:

# TODO: gui currently broken (must be run as cli daemon)

stdenv.mkDerivation rec {
  pname = "globus-connect-personal";
  version = "3.1.1";

  src = requireFile {
    name = "globusconnectpersonal-latest.tgz";
    sha256 = "1l72spkad2w575zcq1b8jh99dlh33x6sqbg6a2y5chdr7dq0yaw1";
    message = ''
      Because it is not possible to download specific versions of Globus Connect
      Personal, this derivation makes no attempt to fetch the source
      automatically. Instead, you must add the source to the nix-store using
      nix-prefetch-url, and then copy the resulting hash into the
      derivation. For example:

      $ nix-prefetch-url https://downloads.globus.org/globus-connect-personal/linux/stable/globusconnectpersonal-latest.tgz

      ... or ...

      $ wget https://downloads.globus.org/globus-connect-personal/linux/stable/globusconnectpersonal-latest.tgz
      $ nix-prefetch-url file://$(pwd)/globus-connect-personal-latest.tgz
    '';
  };

  nativeBuildInputs = [ gnutar makeWrapper autoPatchelfHook ];
  buildInputs = [ libaudit stdenv.cc.cc.lib ];
  propagatedBuildInputs = [ tcllib tk ];

  postPatch = ''
    tclfiles=$(find . -type f -name "*.tcl")
    echo "Patching wish shebangs in the following files:"
    for f in $tclfiles; do
      echo $f
      substituteInPlace $f \
        --replace "#!/usr/bin/wish" "#!${tk}/bin/wish"
    done
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/globusconnectpersonal
    cp -r ./* $out/share/globusconnectpersonal
    ln -s $out/share/globusconnectpersonal/globusconnectpersonal $out/bin/globusconnectpersonal
  '';
}
