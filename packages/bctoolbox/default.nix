{
  bcunit,
  bc-decaf,
  mkLinphoneDerivation,
  openssl,
  lib,

  # tests
  testers,
  bctoolbox,
}:
mkLinphoneDerivation {
  pname = "bctoolbox";

  propagatedBuildInputs = [
    bcunit
    bc-decaf
    openssl
  ];

  extraCmakeFlags = [
    "-DENABLE_STRICT=NO"

    # mbedtils does not build
    "-DENABLE_MBEDTLS=NO"
    "-DENABLE_OPENSSL=YES"
  ];

  strictDeps = true;

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      package = bctoolbox;
      moduleNames = [
        "BCToolbox"
      ];
    };
  };

  meta = with lib; {
    description = "Utilities library for Linphone";
    mainProgram = "bctoolbox_tester";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
