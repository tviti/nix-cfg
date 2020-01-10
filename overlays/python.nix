self: super: {
  myPython3Packages = pythonPackages: with pythonPackages; [
    ipython
  ];
  myPython3 = super.python3.withPackages super.pkgs.myPython3Packages;
}
