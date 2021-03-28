{ stdenv, lib, fetchurl, rpmextract, autoPatchelfHook,
  rpm, json_c, libnl, systemd
}:
stdenv.mkDerivation rec {
  pname = "amsd";
  version = "2.1.1-1412.2";

  src = fetchurl {
    url = "https://downloads.linux.hpe.com/SDR/repo/mcp/centos/8/x86_64/current/amsd-2.1.1-1412.2.centos8.x86_64.rpm";
    sha256 = "1h553bqf2n447iklz83yrashky59j7v5jzhabxa1lzrc0jgsb7xc";
  };

  nativeBuildInputs = [
    rpmextract autoPatchelfHook
    systemd
  ];

  buildInputs = [
    rpm.dev json_c libnl
  ];

  unpackPhase = ''
    rpmextract $src
  '';

  # TODO: Use install instead of cp
  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  # Not sure if this won't cause runtime issues
  postFixup = ''
    ln -s ${rpm}/lib/librpm.so.9 $out/usr/lib/librpm.so.8
    ln -s ${rpm}/lib/librpmio.so.9 $out/usr/lib/librpmio.so.8
    ln -s ${json_c}/lib/libjson-c.so.5 $out/usr/lib/libjson-c.so.4
  '';

  meta = {
    description = "HPE Agentless Management Service";
    maintainers = with lib.maintainers; [ johnazoidberg ];
    license = lib.licenses.unfree;
    homepage = "https://downloads.linux.hpe.com/SDR/project/mcp/";
    platforms = [ "x86_64-linux" ];
  };
}
