{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "texlab";
  version = "1.8.0";

  src = fetchurl {
    url = https://github.com/latex-lsp/texlab/releases/download/v1.8.0/texlab-x86_64-macos.tar.gz;
    sha256 = "0y87fpyl98j4crx72r7gsdhb9s7xwlwg2a18b9dkvnawsdjhwv8z";
  };

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    mkdir ./texlab-x86_64-macos
    cd texlab-x86_64-macos
    tar -xvf $src
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    cp ./texlab $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = https://texlab.netlify.com/;
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
