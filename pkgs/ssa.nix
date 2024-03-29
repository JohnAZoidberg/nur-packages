# hpsmhd is running
# ssa -start
# ssa -stop
{ stdenv, lib, fetchurl, rpmextract, autoPatchelfHook
}:
stdenv.mkDerivation rec {
  pname = "ssa";
  version = "5.10-44.0";

  src = fetchurl {
    url = "https://downloads.linux.hpe.com/SDR/repo/mcp/centos/8/x86_64/current/${pname}-${version}.x86_64.rpm";
    sha256 = "sha256:0sqrrl91gm03871p5bv1ykc7whq6v0ml2jjapa00xzwh6qjkwypi";
  };

  nativeBuildInputs = [
    rpmextract autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    rpmextract $src
  '';

  # TODO: Use install instead of copy
  installPhase = ''
    runHook preInstall

    cp -r usr $out
    cp -r opt $out/

    runHook postInstall
  '';

  # TODO: Fixup manpage not to refer to /opt
  postFixup = ''
    substituteInPlace $out/bin/ssa --replace "/opt" "$out/opt"
    # TODO: Need to replace in the uncompressed file
    #substituteInPlace $out/share/man/man8/ssa.8.gz --replace "/opt" "$out/opt"
  '';

  meta = {
    description = "Command line disk configuration utility for HPE Smart RAID and Smart HBA controllers";
    maintainers = with lib.maintainers; [ johnazoidberg ];
    license = lib.licenses.unfree;
    homepage = "https://downloads.linux.hpe.com/SDR/project/mcp/";
    platforms = [ "x86_64-linux" ];
  };
}
