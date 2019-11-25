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
    mkdir -p $bin/bin $out/bin
    cp ./bin/yabai $out/bin/yabai
  '';

  postInstall = ''
    mkdir -p $out/Library/LaunchDaemons
    cp ${./org.nixos.yabai.plist} $out/Library/LaunchDaemons/org.nixos.yabai.plist
    substituteInPlace $out/Library/LaunchDaemons/org.nixos.yabai.plist --subst-var out
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/koekeishiya/yabai;
    description = ''
      A tiling window manager for macOS based on binary space partitioning.
    '';
    platforms = platforms.darwin;
  };
} 