{ stdenv, lib, fetchurl, perl, nettools, java, polyml, z3 }:
# nettools needed for hostname

let
  version = "2018";
  dirname = "Isabelle${version}";
in

stdenv.mkDerivation {
  name = "isabelle-2018";
  inherit dirname;

  src = if stdenv.isDarwin
    then fetchurl {
      url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}.dmg";
      sha256 = "0jwnvsf5whklq14ihaxs7b9nbic94mm56nvxljrdbvl6y628j9r5";
    }
    else fetchurl {
      url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}_linux.tar.gz";
      sha256 = "1928lwrw1v1p9s23kix30ncpqm8djmrnjixj82f3ni2a8sc3hrsp";
    };

  buildInputs = [ perl polyml z3 ]
             ++ lib.optionals (!stdenv.isDarwin) [ nettools java ];

  sourceRoot = dirname;

  postPatch = ''
    ENV=$(type -p env)
    patchShebangs "."
    substituteInPlace lib/Tools/env \
      --replace /usr/bin/env $ENV
    substituteInPlace lib/Tools/install \
      --replace /usr/bin/env $ENV
    sed -i 's|isabelle_java java|${java}/bin/java|g' lib/Tools/java
    substituteInPlace etc/settings \
      --subst-var-by ML_HOME "${polyml}/bin"
    substituteInPlace contrib/jdk/etc/settings \
      --replace ISABELLE_JDK_HOME= '#ISABELLE_JDK_HOME='
    substituteInPlace contrib/polyml-*/etc/settings \
      --replace '$POLYML_HOME/$ML_PLATFORM' ${polyml}/bin \
      --replace '$POLYML_HOME/$PLATFORM/polyml' ${polyml}/bin/poly
    substituteInPlace lib/scripts/run-polyml* lib/scripts/polyml-version \
      --replace '$ML_HOME/poly' ${polyml}/bin/poly
    substituteInPlace contrib/z3*/etc/settings \
      --replace '$Z3_HOME/z3' '${z3}/bin/z3'

    for comp in contrib/jdk contrib/polyml*; do
      rm -rf $comp/x86*
    done
    '' + (if ! stdenv.isLinux then "" else ''
    arch=${if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64-linux" else "x86-linux"}
    for f in contrib/*/$arch/{bash_process,epclextract,eprover,nunchaku,SPASS}; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f"
    done
    '');

  installPhase = ''
    mkdir -p $out/bin
    mv $TMP/$dirname $out
    cd $out/$dirname
    bin/isabelle install $out/bin
  '';

  meta = {
    description = "A generic proof assistant";

    longDescription = ''
      Isabelle is a generic proof assistant.  It allows mathematical formulas
      to be expressed in a formal language and provides tools for proving those
      formulas in a logical calculus.
    '';
    homepage = http://isabelle.in.tum.de/;
    license = "LGPL";
    maintainers = [ lib.maintainers.jwiegley ];
    platforms = lib.platforms.linux;
  };
}
