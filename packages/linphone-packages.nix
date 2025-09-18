{
  libsForQt5,
  lib,
}:
let
  scope =
    self:
    let
      packages = lib.filterAttrs (name: value: value == "directory") (builtins.readDir ./.);
    in
    {
      mkLinphonePackage = self.callPackage ./mk-linphone-package { };

      linphoneVersion = "5.4.43";
    }
    // (lib.mapAttrs (name: value: self.callPackage ./${name} { }) packages);
in
lib.makeScope libsForQt5.newScope scope
