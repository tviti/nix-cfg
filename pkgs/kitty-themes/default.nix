{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "kitty-themes";
  version = "1.0";
    
  src = fetchFromGitHub {
    owner = "dexpota";
    repo = "kitty-themes";
    rev = "fca3335489bdbab4cce150cb440d3559ff5400e2";
    sha256 = "11dgrf2kqj79hyxhvs31zl4qbi3dz4y7gfwlqyhi4ii729by86qc";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/kitty-themes
    cp -rv ./themes/* $out/share/kitty-themes/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/dexpota/kitty-themes;
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.mit;
    platforms = platforms.darwin ++ platforms.linux;
  };
}
