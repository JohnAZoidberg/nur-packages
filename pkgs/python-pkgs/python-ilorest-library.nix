{ stdenv, lib, fetchFromGitHub, buildPythonPackage
, jsonpatch
, jsonpath_rw
, jsonpointer
, urllib3
, withChif ? false
}:
buildPythonPackage rec {
  pname = "python-ilorest-library";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "HewlettPackard";
    repo = pname;
    rev = "${version}";
    hash = "sha256:0px03kazdvzx79vjs2zv0j91iylc9gvbv2hwpwgziqv8j3sd68jn";
  };

  # libstdc++so.6
  # https://downloads.hpe.com/pub/softlib2/software1/pubsw-linux/p1093353304/v168967/ilorest_chif.so

  propagatedBuildInputs = [
    jsonpatch
    jsonpath_rw
    jsonpointer
    urllib3
  ];

  meta = with lib; {
    description = "TODO";
    license = if withChif then licenses.unfree else licenses.unfree;
    #homepage = https://github.com/Selfnet/hkp4py;
    maintainers = with maintainers; [ johnazoidberg ];
    platforms = platforms.linux;
  };
}

