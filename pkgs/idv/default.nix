{ callPackage, fetchzip, jogl, jre, makeWrapper, unzip, stdenv }:

let
  java3d = callPackage ./java3d.nix { };
in stdenv.mkDerivation rec {
  pname = "idv";
  version = "5.7";

  src = fetchzip {
    url = "https://www.unidata.ucar.edu/downloads/idv/latest/ftp/idv_jars_${version}.zip";
    sha256 = "1yjha9pw0mjaaa35hmr7dn66zfglm7agpfdnk1q3zyqjrl1r8k16";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ java3d jogl jre ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/share/idv
    mkdir -p $out/bin

    cp *.jar $out/share/idv

    makeWrapper "${jre}/bin/java" "$out/bin/idv" \
      --set MESA_LOADER_DRIVER_OVERRIDE i965 \
      --add-flags "-Xmx512m -cp $CLASSPATH:$out/share/idv/auxdata.jar:$out/share/idv/external.jar:$out/share/idv/jython.jar:$out/share/idv/local-visad.jar:$out/share/idv/ncIdv.jar:$out/share/idv/visad.jar:$out/share/idv/idv.jar ucar.unidata.idv.DefaultIdv"
  '';
}
