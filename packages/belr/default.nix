{
  bctoolbox,
  lib,
  mkLinphonePackage,
}:
mkLinphonePackage {
  pname = "belr";

  buildInputs = [
    bctoolbox
  ];

  meta = with lib; {
    description = "Belledonne Communications' language recognition library. Part of the Linphone project";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
