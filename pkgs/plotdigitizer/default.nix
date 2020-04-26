{ apacheAnt, fetchzip, jdk, jre, makeWrapper, stdenv}:

stdenv.mkDerivation rec {
  name = "plot-digitizer";
  ver = "2.6.8";

  src = fetchzip {
    url = "mirror://sourceforge/plotdigitizer/PlotDigitizer_2.6.8_Source.zip";
    sha256 = "1aq89yv86nb52qryr9m1x777fis51j20xsqg6v6sak1pi0nifr3p";
  };

  # patches = [ ./build.patch ];

  nativeBuildInputs = [ apacheAnt jdk makeWrapper ];

  buildPhase = "ant jar";

  installPhase = ''
    mkdir -p $out/share/java
    cp jars/PlotDigitizer.jar $out/share/java/PlotDigitizer.jar
    makeWrapper "${jre}/bin/java" "$out/bin/PlotDigitizer" \
      --add-flags "-Xmx256m -jar $out/share/java/PlotDigitizer.jar"
  '';

  meta = {
    homepage = "http://plotdigitizer.sourceforge.net/";
    description = "Java program used to digitize scanned plots";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
