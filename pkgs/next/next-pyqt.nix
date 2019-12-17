{ qtbase, stdenv, wrapQtAppsHook, python3, libsForQt5, callPackage}:

let
  next = callPackage /home/tviti/.config/nixpkgs/pkgs/next { };
  # mypyqtwebengine = libsForQt5.callPackage /home/tviti/.config/nixpkgs/pkgs/pyqtwebengine/default.nix { };
  python-pkgs = python-packages: with python-packages ;[
    pyqt5 pyqtwebengine #mypyqtwebengine
  ];
  next-python = python3.withPackages python-pkgs;
in stdenv.mkDerivation rec {
  name = "next-pyqt";
  inherit (next) src version;

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    next-python
  ];
  
  phases = [ "patchPhase" "installPhase" "postFixup" ];

  patchPhase = ''
    cp -rv ${src}/ports/pyqt-webengine ./
    substituteInPlace pyqt-webengine/next-pyqt-webengine.py \
      --replace "#!/usr/bin/env python3" "#!${next-python}/bin/python3"

    # setUrlRequestInterceptor doesn't exist till pyqtwebengine >= 5.13
    substituteInPlace pyqt-webengine/buffers.py \
      --replace setUrlRequestInterceptor setRequestInterceptor
  '';

  installPhase = ''
    mkdir -p $out/next-pyqt-webengine
    cp -rv ./pyqt-webengine/* $out/next-pyqt-webengine/
    mv $out/next-pyqt-webengine/next-pyqt-webengine.py \
       $out/next-pyqt-webengine/next-pyqt-webengine
    mkdir -p $out/bin
    ln -s $out/next-pyqt-webengine/next-pyqt-webengine $out/bin
  '';

  dontWrapQtApps = true;

  postFixup = ''
    wrapProgram $out/next-pyqt-webengine/next-pyqt-webengine \
      "''${qtWrapperArgs[@]}"
  '';

  meta = with stdenv; { platforms = [ "x86_64-linux" "x86_64-darwin" ]; };
}

