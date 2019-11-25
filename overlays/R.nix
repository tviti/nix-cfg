/*
Install R w/ CRAN packages.

Example usage:
    # From within home.nix (using home_manager)
    home.packages. = [ 
      # ...
      R-with-my-packages
      # ...
    ];
*/

self: super:
{
  R-with-my-packages = with super.pkgs; rWrapper.override {
    packages = with rPackages; [
      ggplot2
      rstan
      lintr
    ];
  };
}
