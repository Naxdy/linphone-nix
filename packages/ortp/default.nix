{
  bctoolbox,
  lib,
  mkLinphoneDerivation,
}:
mkLinphoneDerivation {
  pname = "ortp";

  env.NIX_CFLAGS_COMPILE = "-Wno-error=stringop-truncation";

  buildInputs = [ bctoolbox ];

  meta = with lib; {
    description = "Real-Time Transport Protocol (RFC3550) stack. Part of the Linphone project";
    mainProgram = "ortp_tester";
    license = licenses.gpl3Plus;
  };
}
