{
  bctoolbox,
  sqlite,
  lib,
  mkLinphonePackage,
}:
mkLinphonePackage {
  pname = "bzrtp";

  patches = [
    ./find-openssl.patch
  ];

  buildInputs = [
    bctoolbox
    sqlite
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=stringop-overflow"
    "-Wno-error=unused-parameter"
  ];

  meta = with lib; {
    description = "Opensource implementation of ZRTP keys exchange protocol. Part of the Linphone project";
    license = licenses.gpl3Plus;
  };
}
