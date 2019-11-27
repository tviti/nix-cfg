# R w/ CRAN packages.

self: super: {
  R-with-my-packages = with super.pkgs;
    rWrapper.override { packages = with rPackages; [ ggplot2 rstan lintr ]; };
}
