{ python3Packages, fetchFromGitHub, installShellFiles }:

let
  # globus-cli reqs pin this at v0.9.4
  jmespath = python3Packages.jmespath.overrideAttrs(oldAttrs: rec {
    version = "0.9.4";
    src = python3Packages.fetchPypi {
      inherit (oldAttrs) pname;
      inherit version;
      sha256 = "bde2aef6f44302dfb30320115b17d030798de8c4110e28d5cf6cf91a7a31074c";
    };
  });
in python3Packages.buildPythonApplication rec {
  pname = "globus-cli";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "globus";
    repo = "globus-cli";
    rev = "${version}";
    sha256 = "1njh4gfgqg5jl23rbnsrb44mapbrsypb0mpds77j2yj14fk48yx3"; 
  };

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];
  propagatedBuildInputs = [ jmespath ] ++ (with python3Packages; [
    configobj
    click
    globus-sdk
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
