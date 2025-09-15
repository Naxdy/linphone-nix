{
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  lib,
}:
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "linphone";
  f =
    self:
    let
      inherit (self) callPackage;

      packages = lib.filterAttrs (name: value: value == "directory") (builtins.readDir ./.);
    in
    {
      mkLinphonePackage = callPackage ./mk-linphone-package { };
    }
    // (lib.mapAttrs (name: value: callPackage ./${name} { }) packages);
}
