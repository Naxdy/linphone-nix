{
  bctoolbox,
  belr,
  lib,
  mkLinphonePackage,

  # tests
  belcard,
  testers,
}:
mkLinphonePackage {
  pname = "belcard";

  buildInputs = [
    bctoolbox
    belr
  ];

  extraCmakeFlags = [
    "-DENABLE_UNIT_TESTS=NO" # Do not build test executables
  ];

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      package = belcard;
      moduleNames = [
        "BelCard"
      ];
    };
  };

  meta = with lib; {
    description = "C++ library to manipulate VCard standard format. Part of the Linphone project";
    license = licenses.gpl3Plus;
  };
}
