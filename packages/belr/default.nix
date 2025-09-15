{
  bctoolbox,
  lib,
  mkLinphonePackage,
}:
mkLinphonePackage {
  pname = "belr";

  patches = [
    # since we are building bctoolbox with openssl instead of mbedtls,
    # we need to find it here
    ./find-openssl.patch
  ];

  buildInputs = [
    bctoolbox
  ];

  meta = with lib; {
    description = "Belledonne Communications' language recognition library. Part of the Linphone project";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
