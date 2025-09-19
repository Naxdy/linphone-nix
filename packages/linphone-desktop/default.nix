{
  bctoolbox,
  belcard,
  belle-sip,
  belr,
  cmake,
  fetchFromGitLab,
  lib,
  liblinphone,
  mediastreamer2,
  msopenh264,
  minizip-ng,
  stdenv,
  qtgraphicaleffects,
  qtmultimedia,
  qtquickcontrols2,
  qttools,
  wrapQtAppsHook,
  xercesc,
  bc-soci,
  lime,
  python3,
  python3Packages,
  zxing-cpp,
  doxygen,
  boost,
  bc-ispell,
  qtbase,
  symlinkJoin,
}:
# How to update Linphone? (The Qt desktop app)
#
# Belledonne Communications (BC), the company making Linphone, has split the
# project into several sub-projects that they maintain, plus some third-party
# dependencies that they also extend with commits of their own, specific to
# Linphone and not (yet?) upstreamed.
#
# All of this is organised in a Software Development Kit (SDK) meta-repository
# with git submodules to pin all those repositories into a coherent whole.
#
# The Linphone Qt desktop app uses this SDK as submodule as well.
#
# So, in order to update the desktop app to a new release, one has to follow
# the submodule chain and update the corresponding derivations here, in nixpkgs,
# with the corresponding version number (or commit hash)

let
  grammarPackages = [
    belle-sip
    belcard
    liblinphone
  ];

  grammars = symlinkJoin {
    name = "belr-grammars";
    paths = map (e: "${e}/share/belr/grammars") grammarPackages;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "linphone-desktop";
  version = "5.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.linphone.org";
    owner = "public";
    group = "BC";
    repo = "linphone-desktop";
    rev = finalAttrs.version;
    hash = "sha256-SxYI2ZOtA49K2XPoTRPAIziAwC8SRrHMC3NISBFyuH0=";
  };

  patches = [
    ./require-finding-packages.patch
    ./remove-bc-versions.patch
    ./do-not-override-install-prefix.patch
    ./fix-translation-dirs.patch
    ./unset-qml-dir.patch
  ];

  # TODO: After linphone-desktop and liblinphone split into separate packages,
  # there might be some build inputs here that aren't needed for
  # linphone-desktop.
  buildInputs = [
    # Made by BC
    bctoolbox
    belcard
    belle-sip
    belr
    liblinphone
    mediastreamer2
    msopenh264
    lime
    bc-soci
    bc-ispell

    xercesc
    minizip-ng
    qtgraphicaleffects
    qtmultimedia
    qtquickcontrols2
    zxing-cpp
    boost

    python3Packages.pystache
    python3Packages.six
  ];

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
    python3
    doxygen
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DMINIZIP_INCLUDE_DIRS=${minizip-ng}/include"
    "-DMINIZIP_LIBRARIES=minizip"

    # RPATH of binary /nix/store/.../bin/... contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"

    # Requires EQt5Keychain
    "-DENABLE_QT_KEYCHAIN=OFF"

    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DLINPHONEAPP_VERSION=${finalAttrs.version}"
    "-DLINPHONE_QT_ONLY=ON"
    "-DLINPHONEAPP_INSTALL_PREFIX=${placeholder "out"}"
    "-DLINPHONE_QML_DIR=${placeholder "out"}/${qtbase.qtQmlPrefix}/ui"

    # normally set by the custom find modules, which we have to disable
    "-DLibLinphone_TARGET=liblinphone"
    "-DLinphoneCxx_TARGET=liblinphone++"
    "-DISpell_SOURCE_DIR=${bc-ispell.src}"
  ];

  preConfigure = ''
    # custom "find" modules are causing issues during build,
    # as they are blinding cmake to nix dependencies
    rm -rf linphone-app/cmake
  '';

  preInstall = ''
    mkdir -p $out/share/linphone
    mkdir -p $out/share/sounds/linphone
    mkdir -p $out/share/belr
  '';

  # In order to find mediastreamer plugins, mediastreamer package was patched to
  # support an environment variable pointing to the plugin directory. Set that
  # environment variable by wrapping the Linphone executable.
  #
  # Also, some grammar files needed to be copied too from some dependencies. I
  # suppose if one define a dependency in such a way that its share directory is
  # found, then this copying would be unnecessary. These missing grammar files
  # were discovered when linphone crashed at startup and it was run with
  # --verbose flag. Instead of actually copying these files, create symlinks.
  #
  # It is quite likely that there are some other files still missing and
  # Linphone will randomly crash when it tries to access those files. Then,
  # those just need to be copied manually below.
  postInstall = ''
    mkdir -p $out/lib/mediastreamer/plugins
    ln -s ${msopenh264}/lib/mediastreamer/plugins/* $out/lib/mediastreamer/plugins/
    ln -s ${mediastreamer2}/lib/mediastreamer/plugins/* $out/lib/mediastreamer/plugins/
    ln -s ${grammars} $out/share/belr/grammars

    wrapProgram $out/bin/linphone \
      --unset QML2_IMPORT_PATH \
      --set MEDIASTREAMER_PLUGINS_DIR $out/lib/mediastreamer/plugins
  '';

  meta = with lib; {
    homepage = "https://www.linphone.org/";
    description = "Open source SIP phone for voice/video calls and instant messaging";
    mainProgram = "linphone";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ naxdy ];
  };
})
