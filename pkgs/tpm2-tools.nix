{ lib, stdenv, libtool, pkgconfig, libgcrypt, tpm-tss, openssl, curl, pandoc,
  python36, file
}:
stdenv.mkDerivation rec {
  version = "3.1.2";
  name = "tpm-tools-${version}";

  src = fetchTarball {
    url = "https://github.com/tpm2-software/tpm2-tools/releases/download/${version}/tpm2-tools-${version}.tar.gz";
    sha256 = "1p1mj5s095m71xp0gp1fibmv3h6fp9f66byf8shay017gma3i138";
  };

  buildInputs = [
    libtool pkgconfig
    tpm-tss
    openssl libgcrypt
    curl.dev

    pandoc
    (python36.withPackages(ps: with ps; [ pyyaml ]))
  ];

  preConfigure = ''
    substituteInPlace configure --replace "/usr/bin/file" "${file}/bin/file"
  '';

  # TODO enable unit tests

  meta = {
    homepage = https://github.com/tpm2-software/tpm2-tools;
    description = "The source repository for the TPM (Trusted Platform Module) 2 tools";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.johnazoidberg ];
  };
}
