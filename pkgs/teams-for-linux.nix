{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3 }:
let
  pname = "teams-for-linux";
  version = "0.3.0";
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/IsmaelMartinez/teams-for-linux/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    sha256 = "1wsq97lw5kx0zfj7d5h91msx5fvxqgn1k49njy8c02kcqnvhqmcp";
  };

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "Unofficial Microsoft Teams for Linux client";
    homepage = https://github.com/IsmaelMartinez/teams-for-linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = [ "x86_64-linux" ];
  };
}
