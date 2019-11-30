/* A derivation that installs the yabai window manager. See also services/yabai.nix
   for the definition of the associated system service.
*/

{ pkgs, stdenv, fetchFromGitHub, Carbon, Cocoa, ScriptingBridge, ... }:

stdenv.mkDerivation rec {
  pname = "yabai";
  version = "v2.1.3";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "yabai";
    rev = "${version}";
    sha256 = "1g8ilbnr0vs4gn4a17jdrlhl3x3jrb5c43cgpwnzxc518dcyba2f";
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
