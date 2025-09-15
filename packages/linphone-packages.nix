{
  makeScopeWithSplicing',
  generateSplicesForMkScope,
}:
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "linphone";
  f =
    self:
    let
      inherit (self) callPackage;
    in
    {
      mkLinphonePackage = callPackage ./mk-linphone-package { };

      bcunit = callPackage ./bcunit { };
    };
}
