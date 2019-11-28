/* A derivation that installs the yabai window manager. See also services/yabai.nix
   for the definition of the associated system service.
*/

{ pkgs, stdenv, fetchFromGitHub, Carbon, Cocoa, ScriptingBridge }:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "033b7c17c8607f59ac4318d799761d6739aa272a";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "yabai";
    rev = "${version}";
    sha256 = "0bfag249kk5k25imwxassz0wp6682gjzkhr38dibbrrqvdwig3pg";
  };

  buildInputs = [ Carbon Cocoa ScriptingBridge ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1/
    cp ./bin/yabai $out/bin/yabai
    cp ./doc/yabai.1 $out/share/man/man1/yabai.1
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/koekeishiya/yabai";
    description = ''
      A tiling window manager for macOS based on binary space partitioning.
    '';
    platforms = platforms.darwin;
    license = "MIT";
  };
}
