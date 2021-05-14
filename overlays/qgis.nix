self: super: {
  qgis-unwrapped = super.qgis-unwrapped.overrideAttrs (oldAttrs: rec {
    buildInputs = oldAttrs.buildInputs ++ [ super.qt5.qt3d ];
    cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DWITH_3D=ON" ];
  });
}
