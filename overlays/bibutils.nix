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
