/* A derivation for building Next browser with the PyQtWebEngine frontend. This was
   originally written to install on a Darwin system, and I have had problems with
   getting it working on a CentOS 7 machine (the next-pyqt derivation fails to
   install PyQt5 and PyQtWebEngine).

   Note that this derivation clones from my own fork of the next repo (i.e. this
   is not using the official next source).

   Since the nixpkgs libfixposix derivation does not support Darwin, I have
   packaged it myself (with the .nix file based on the brew recipe). It would
   probably be better to actually pass this dependency as an argument, but since
   we rely on this specific derivation, I just call it directly from
   here. Ideally, we would also let nix handle the quicklisp dependencies, but
   those nixpkgs also don't support Darwin (ASDF is the first to throw an
   error), hence this package uses quicklisp directly.  */

{ stdenv, xclip, pass, fetchFromGitHub, sbcl, callPackage, lispPackages, libsForQt5 }:

let
  next-pyqt = libsForQt5.callPackage ./next-pyqt.nix { };
in stdenv.mkDerivation rec {
  name = "next";
  version = "v1.3.4";

  src = fetchFromGitHub {
    owner = "tviti";
    repo = "next";
    rev = "ba0f1fc1cfa09fee544d61cf6e3848e1e0b7aa57";
    sha256 = "0c6xdnbpyydwhg5pdp1498wmmgg0bd1drypyl2rxpagibbmsx9kd";
  };

  # Stripping destroys the generated SBCL image
  dontStrip = true;

  nativeBuildInputs = [
    sbcl
  ] ++ (with lispPackages; [
    prove-asdf
    trivial-features
  ]);

  buildInputs = [
    xclip
    pass
  ] ++ (with lispPackages; [
    alexandria
    bordeaux-threads
    cl-annot
    cl-ansi-text
    cl-css
    cl-hooks
    cl-json
    cl-markup
    cl-ppcre
    cl-ppcre-unicode
    cl-prevalence
    closer-mop
    dbus
    dexador
    ironclad
    local-time
    log4cl
    lparallel
    mk-string-metrics
    parenscript
    quri
    sqlite
    str
    swank
    trivia
    trivial-clipboard
    trivial-types
    unix-opts
  ]);

  propagatedBuildInputs = [ next-pyqt ];

  prePatch = ''
    substituteInPlace source/ports/gtk-webkit.lisp \
      --replace "next-gtk-webkit" "${next-pyqt}/next-pyqt-webengine/next-pyqt-webengine"
  '';

  # Quicklisp will want to create a few hidden-/dot-dirs in $HOME (which will
  # fail due to nix' use of homeless-shelter), so we instead point it to $out
  buildPhase = if stdenv.isDarwin then ''
    export HOME=$out/Applications/Next.app/Contents/MacOS/
    mkdir -p $out/Applications/Next.app/Contents/MacOS/
    make app-bundle
  '' else ''
    common-lisp.sh --eval "(require :asdf)" \
                   --eval "(asdf:load-asd (truename \"next.asd\") :name \"next\")" \
                   --eval '(asdf:make :next)' \
                   --quit
  '';

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/bin
    cp -rv ./Next.app $out/Applications/
    rm -rf ./Next.app
    ln -s $out/Applications/Next.app/Contents/MacOS/next $out/bin/next
  '' else ''
    install -D -m0755 next $out/bin/next
  '';

  meta = with stdenv; { platforms = [ "x86_64-linux" "x86_64-darwin" ]; };

}
