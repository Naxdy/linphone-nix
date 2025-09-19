{
  stdenv,
  fetchFromGitLab,
  lib,
  cmake,
  linphoneVersion,
}:
{
  pname,
  sourceRoot ? pname,
  extraCmakeFlags ? [ ],
  extraNativeBuildInputs ? [ ],
  removeFindModules ? [ ],
  ...
}@args:
stdenv.mkDerivation (
  finalAttrs:
  (lib.recursiveUpdate
    {
      inherit pname;
      version = linphoneVersion;

      src = fetchFromGitLab {
        domain = "gitlab.linphone.org";
        owner = "public";
        group = "BC";
        repo = "linphone-sdk";
        rev = linphoneVersion;
        hash = "sha256-lv2phU2qF51OIejzjgaBUo9NIdDv4bbK+bpY37Gnr8U=";
        fetchSubmodules = true;
      };

      # some linphone packages have custom find modules
      # for libraries which conflict with Nix' functionality
      preConfigure =
        (builtins.concatStringsSep "\n" (map (e: "rm cmake/Find${e}.cmake || true") removeFindModules))
        + (lib.optionalString (args ? preConfigure) args.preConfigure);

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
        "preConfigure"
      ]
    )
  )
)
