{
  lib,
  bc-soci,
  belcard,
  belle-sip,
  cmake,
  doxygen,
  jsoncpp,
  libxml2,
  lime,
  mediastreamer2,
  python3,
  sqlite,
  xercesc,
  zxing-cpp,
  mkLinphoneDerivation,
}:
mkLinphoneDerivation {
  pname = "liblinphone";

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace "jsoncpp_object" "jsoncpp" \
      --replace "jsoncpp_static" "jsoncpp"
  '';

  extraCmakeFlags = [
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
    "-DENABLE_STRICT=NO" # Do not build with -Werror
  ];

  buildInputs = [
    # Made by BC
    belcard
    belle-sip
    lime
    mediastreamer2

    # Vendored by BC
    bc-soci

    jsoncpp
    libxml2
    sqlite
    xercesc
    zxing-cpp
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    (python3.withPackages (ps: [
      ps.pystache
      ps.six
    ]))
  ];

  strictDeps = true;

  # Some grammar files needed to be copied too from some dependencies. I suppose
  # if one define a dependency in such a way that its share directory is found,
  # then this copying would be unnecessary. Instead of actually copying these
  # files, create a symlink.
  postInstall = ''
    mkdir -p $out/share/belr/grammars
    ln -s ${belcard}/share/belr/grammars/* $out/share/belr/grammars/
  '';

  meta = with lib; {
    description = "Library for SIP calls and instant messaging";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
