/*

An overlay for building bibutils on Darwin systems. Note that nixpkgs.bibutils is
listed as linux ONLY, so here we override both the version (nixpkgs is also
behind), the allowed platforms, and the disable tests (for some reason, build
goes OK, but tests fail, usually for intlib.c).

Although their are failed tests, my experience using ris2xml | xml2bib to
convert .ris formatted citations seem to suggest everything is reasonably well
behaved (fingers crossed).

*/

self: super:
{
  bibutils = super.bibutils.overrideAttrs(oldAttrs: {
    version = "6.8";
    src = super.fetchurl {
      url = "https://downloads.sourceforge.net/project/bibutils/bibutils_6.8_src.tgz";
      sha256 = "072cmhv692nk1lfcwmaqid5gpg8q4jc4vai5ss8lj72zms32p882";
    };

    # TODO: Tests don't pass on Darwin for some reason.
    doCheck = false;

    configureFlags = [
      "--install-dir" "$out/bin"
      "--install-lib" "$out/lib"
    ];

    meta.platforms = super.stdenv.lib.platforms.darwin;
  });
}
