/* A derivation that installs the yabai window manager. See also services/yabai.nix
   for the definition of the associated system service.
*/

{ pkgs, stdenv, fetchFromGitHub, Carbon, Cocoa, ScriptingBridge, ... }:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "033b7c17c8607f59ac4318d799761d6739aa272a";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "yabai";
    rev = "${version}";
    sha256 = "1hmkcp0wxfamjqkp6xhrvm86rsh7q664sl0gd1ikz09jf4ywp897";
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
