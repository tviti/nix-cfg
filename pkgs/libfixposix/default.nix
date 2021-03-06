/* A derivation for building libfixposix on Darwin systems (for some reason, the
   nixpkgs derivation is linux only). This probably doesn't have to be an entire
   derivation (an overlay that overrides meta.platforms might be sufficient).
*/

{ pkgs, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libfixposix";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "sionescu";
    repo = "libfixposix";
    rev = "v${version}";
    sha256 = "1x4q6yspi5g2s98vq4qszw4z3zjgk9l5zs8471w4d4cs6l97w08j";
  };

  # Taken from the libfixposix brew recipe
  configurePhase = ''
    autoreconf -fvi
    ./configure --disable-dependency-tracking \
                --disable-silent-rules \
                --prefix=$out
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = with pkgs; [ git getconf ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sionescu/libfixposix";
    description =
      "Thin wrapper over POSIX syscalls and some replacement functionality";
    license = licenses.boost;
    platforms = platforms.darwin;
  };

}
