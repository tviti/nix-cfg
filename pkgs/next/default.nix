/* A derivation for building Next browser with the PyQtWebEngine frontend,
   cloning from my own fork of the next repo (i.e. this is not using the
   official next source). This was originally written to install on a Darwin
   system. Linux specific bits were largely taken from the nixpkgs derivation.

   Since the nixpkgs libfixposix derivation does not support Darwin, I have
   packaged it myself for use on macOS machines (with the .nix file based on the
   brew recipe).

   Note that the macOS derivation is very "dirty" my nix-an standards, as it
pulls in dependencies using pip and quicklisp directly.  */

{ stdenv, xclip, pass, fetchFromGitHub, sbcl, callPackage, lispPackages, curl
, cacert, libsForQt5, libfixposix }:

let
  next-pyqt = if stdenv.isDarwin then
    callPackage ./next-pyqt-darwin.nix { }
  else
    libsForQt5.callPackage ./next-pyqt.nix { };
in stdenv.mkDerivation rec {
  name = "next";
  version = "v1.3.4";

  src = fetchFromGitHub {
    owner = "tviti";
    repo = "next";
    rev = "57cb6b3ebb185d5eda0df7f53303d50c83ccd1db";
    sha256 = "1c1kl3ddp33ydzrq27ihfwg3xaiaqlxz9s6rcnwdwkb918igrx9z";
  };

  # Stripping destroys the generated SBCL image
  dontStrip = true;

  nativeBuildInputs = if stdenv.isDarwin then
    [ sbcl libfixposix ]
  else
    [ sbcl ] ++ (with lispPackages; [ prove-asdf trivial-features ]);

  buildInputs = if stdenv.isDarwin then [
    curl
    cacert
    pass
  ] else
    [ xclip pass ] ++ (with lispPackages; [
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

  # On linux, Next defaults to gtk-webkit, so here we do a dirty patch to
  # force it to instead use pyqtwebengine.
  prePatch = if stdenv.isDarwin then ''
    substituteInPlace ./ports/pyqt-webengine/next-pyqt-webengine.py \
        --replace "#!/usr/bin/env python3" "#!${next-pyqt}/bin/python"
  '' else ''
    substituteInPlace source/ports/gtk-webkit.lisp \
      --replace "next-gtk-webkit" \
                "${next-pyqt}/next-pyqt-webengine/next-pyqt-webengine"
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

    substituteInPlace assets/next.desktop \
      --replace "VERSION" "${version}"

    mkdir -p $out/share/applications
    cp assets/next.desktop $out/share/applications/next.desktop
  '';

  meta = with stdenv; { platforms = [ "x86_64-linux" "x86_64-darwin" ]; };
}
