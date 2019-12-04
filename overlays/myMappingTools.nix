# GMT and support packages.

self: super:
let
  gmt = super.pkgs.callPackage ../pkgs/gmt {
    inherit (super.pkgs.darwin.apple_sdk.frameworks)
      Accelerate CoreGraphics CoreVideo;
  };
in {
  myMappingTools = with super.pkgs; [
    gmt
    gdal # Useful for file format conversion (e.g. shapefile/kml to gmt)
    ghostscript # Needed by gmt to convert postscript to other formats
  ];
}
