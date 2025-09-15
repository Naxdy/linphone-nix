{
  stdenv,
  fetchFromGitLab,
  lib,
  cmake,
}:
{
  pname,
  sourceRoot ? pname,
  extraCmakeFlags ? [ ],
  extraNativeBuildInputs ? [ ],
  ...
}@args:
stdenv.mkDerivation (
  finalAttrs:
  (lib.recursiveUpdate
    {
      inherit pname;
      version = "5.4.43";

      src = fetchFromGitLab {
        domain = "gitlab.linphone.org";
        owner = "public";
        group = "BC";
        repo = "linphone-sdk";
        rev = finalAttrs.version;
        hash = "sha256-lv2phU2qF51OIejzjgaBUo9NIdDv4bbK+bpY37Gnr8U=";
        fetchSubmodules = true;
      };

      nativeBuildInputs = [
        cmake
      ]
      ++ extraNativeBuildInputs;

      sourceRoot = "${finalAttrs.src.name}/${sourceRoot}";

      cmakeFlags = [
        "-DBUILD_SHARED_LIBS=ON"
      ]
      ++ extraCmakeFlags;

      meta = {
        homepage = "https://gitlab.linphone.org/BC/public/linphone-sdk";
        maintainers = [ lib.maintainers.naxdy ];
        platforms = lib.platforms.all;
      };
    }
    (
      builtins.removeAttrs args [
        "extraCmakeFlags"
        "extraNativeBuildInputs"
        "pname"
        "sourceRoot"
      ]
    )
  )
)
