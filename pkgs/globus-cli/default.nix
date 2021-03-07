{ python3Packages, fetchFromGitHub, installShellFiles, callPackage }:

let
  # globus-cli reqs pin this at v0.9.4
  jmespath = python3Packages.jmespath.overrideAttrs(oldAttrs: rec {
    version = "0.10.0";
    src = python3Packages.fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "1yflbqggg1z9ndw9ps771hy36d07j9l2wwbj66lljqb6p1khapdq";
    };
  });
  # requires v1.9.0
  globus-sdk = python3Packages.globus-sdk.overrideAttrs(oldAttrs: rec {
    version = "1.9.0";
    src = fetchFromGitHub {
      owner = "globus";
      repo = "globus-sdk-python";
      rev =  version;
      sha256 = "1kqnr50iwcq9nx40lblbqzf327cdcbkrir6vh70067hk33rq0gm9";
    };
  });
in python3Packages.buildPythonApplication rec {
  pname = "globus-cli";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "globus";
    repo = "globus-cli";
    rev = "${version}";
    sha256 = "1n5ysbrrzvhikvr5xn9sfws03km5xch50av9rng8ijxm54nj81gn"; 
  };

  doCheck = false;

  # Override pin for cryptography, cause lazy
  patchPhase = ''
    substituteInPlace setup.py --replace \
      "cryptography>=1.8.1,<3.4.0" "cryptography>=1.8.1,<=3.4.6"
  '';
  
  nativeBuildInputs = [ installShellFiles ];
  propagatedBuildInputs = [ jmespath # cryptography
                            globus-sdk ] ++ (with python3Packages; [
                              cryptography
    configobj
    click
    six
  ]);

  postPatch = ''
    sed -i '1d' shell_completion/{bash,zsh}_complete.sh
  '';
  
  postInstall = ''
    installShellCompletion --bash --name globus shell_completion/bash_complete.sh
    installShellCompletion --zsh --name _globus shell_completion/zsh_complete.sh
  '';
}
