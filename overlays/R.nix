# R w/ CRAN packages.

self: super: {
  myR = with super.pkgs;
    rWrapper.override { packages = with rPackages; [ languageserver ggplot2 rstan lintr ]; };
}
