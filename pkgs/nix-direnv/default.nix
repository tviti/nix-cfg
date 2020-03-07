{ fetchFromGitHub, stdenv }:

stdenv.mkDerivation {
  name = "nix-direnv";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-direnv";
    rev = "81d3f5083ae68aec5d9f6fc9eebac57c82a9d280";
    sha256 = "067493hbsij59bvaqi38iybacqbzwx876dvdm651b5mn3zs3h42c";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/nix-direnv
    cp -rv ./* $out/share/nix-direnv
  '';
}
