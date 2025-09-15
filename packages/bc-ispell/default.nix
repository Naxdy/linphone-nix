{
  cmake,
  fetchFromGitLab,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "bc-ispell";
  version = "unstable-2025-05-05";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    group = "BC";
    owner = "public/external";
    repo = "ispell";
    rev = "05574fe160222c3d0b6283c1433c9b087271fad1";
    sha256 = "sha256-YoRLiMjk2BxoI27xc2nzucxfHV9UbouFRSECb3RdHGo=";
  };

  patches = [
    ./install-config-files.patch
  ];

  cmakeFlags = [
    # Do not build static libraries
    "-DENABLE_STATIC=NO"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Spell Checker";
    homepage = "https://gitlab.linphone.org/BC/public/external/ispell";
    platforms = platforms.all;
    maintainers = with maintainers; [ naxdy ];
  };
}
