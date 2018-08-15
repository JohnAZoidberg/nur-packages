{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig, uriparser, autoconf-archive, libgcrypt, tpm-tss, openssl, curl, pandoc, m4 }:
stdenv.mkDerivation rec {
  version = "3.0.4";
  name = "tpm-tools-${version}";

  src = fetchFromGitHub {
    owner ="tpm2-software";
    repo = "tpm2-tools";
    rev = "3.0.4";
    sha256 = "1lpw8m9n0bc9b5hbdlmsmd70y5lz6gb5grl9kdipv79p1scqnz4h";
  };

  nativeBuildInputs = [
    autoconf automake libtool pkgconfig
    uriparser autoconf-archive libgcrypt
    tpm-tss
    openssl
    curl.dev
    curl.out

    pandoc
    m4
  ];

  preConfigure = ''
    export PKG_CONFIG_PATH="${tpm-tss}/lib/pkgconfig:$PKG_CONFIG_PATH"
    echo WAAAAAAH
    echo $PKG_CONFIG_PATH
    echo WAAAAAAH
    ./bootstrap
  '';

  meta = {
    homepage = https://github.com/tpm2-software/tpm2-tools;
    description = "The source repository for the TPM (Trusted Platform Module) 2 tools";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.johnazoidberg ];
  };
}
