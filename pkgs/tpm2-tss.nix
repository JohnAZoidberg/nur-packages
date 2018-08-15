{ lib, stdenv, fetchFromGitHub, libtool, autoconf, automake, pkgconfig, uriparser, autoconf-archive, libgcrypt }:

stdenv.mkDerivation rec {
  name = "tpm-tss-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner ="tpm2-software";
    repo = "tpm2-tss";
    rev = version;
    #sha256 = "1ih2s578h7ic48v6p5d4ll03c7k16pckiijj4y8mxsnh9yg5zniz";  # 2.0.0_rc2
    sha256 = "19m5q890484i2ya9jngj1694l2wsck5x3h0i9bvamz35pjlfrwds";  # 1.4.0
  };

  nativeBuildInputs = [
    libtool autoconf automake pkgconfig uriparser autoconf-archive libgcrypt
  ];

  preConfigure = ''
    substituteInPlace bootstrap --replace "git describe --tags --always --dirty" "echo ${version}"
    ./bootstrap
  '';

  meta = {
    homepage = https://github.com/tpm2-software/tpm2-tss;
    description = "OSS implementation of the TCG TPM2 Software Stack (TSS2)";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.johnazoidberg ];
  };
}
