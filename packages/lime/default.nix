{
  bctoolbox,
  belle-sip,
  lib,
  bc-soci,
  sqlite,
  mkLinphoneDerivation,
}:
mkLinphoneDerivation {
  pname = "lime";

  buildInputs = [
    # Made by BC
    bctoolbox
    belle-sip

    # Vendored by BC
    bc-soci

    sqlite
  ];

  extraCmakeFlags = [
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
  ];

  meta = with lib; {
    description = "End-to-end encryption library for instant messaging. Part of the Linphone project";
    license = licenses.gpl3Only;
  };
}
