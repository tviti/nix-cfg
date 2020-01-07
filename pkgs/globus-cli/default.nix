{ python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "globus-cli";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15cxyckl4r85ls23rj6q519p9jil511dm8406m9jfvbn532m181l";
  };

  checkPhase = ''
    py.test tests
  '';

  # No tests in archive
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    configobj
    click
    jmespath
    globus-sdk
  ];
}
