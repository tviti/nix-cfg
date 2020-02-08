/* A derivation that installs the yabai window manager. See also services/yabai.nix
   for the definition of the associated system service.
*/

{ pkgs, stdenv, fetchFromGitHub, Carbon, Cocoa, ScriptingBridge, ... }:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "v2.2.2";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "yabai";
    rev = "${version}";
    sha256 = "0379ppvzvz0hf0carbmyp4rsbd8lipc1g2dwk5324q7iypfv3yrp";
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
