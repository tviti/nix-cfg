self: super: {
  qgis-unwrapped = super.qgis-unwrapped.overrideAttrs (oldAttrs: rec {
    version = "3.14.15";

    src = super.fetchFromGitHub {
      owner = "qgis";
      repo = "QGIS";
      rev = "final-${super.lib.replaceStrings ["."] ["_"] version}";
      sha256 = "03skj8dd5rqi5k22zi8bly1sbynywm2bv6184dhjvw4i2vv4p3rl";
    };

    buildInputs = oldAttrs.buildInputs ++ [ super.protobuf ];
  });
}
