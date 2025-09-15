{
  bctoolbox,
  belr,
  lib,
  mkLinphonePackage,
}:
mkLinphonePackage {
  pname = "belcard";

  patches = [
    ./find-openssl.patch
  ];

  buildInputs = [
    bctoolbox
    belr
  ];

  extraCmakeFlags = [
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
  ];

  meta = with lib; {
    description = "C++ library to manipulate VCard standard format. Part of the Linphone project";
    license = licenses.gpl3Plus;
  };
}
