{ config, pkgs, lib, ... }:

{
  system.activationScripts =
  {
    rainloop =
    {
      deps = [];
      path = [pkgs.gnupg pkgs.rsync pkgs.unzip];
      text = lib.readFile ./data/upgrade-rainloop;
    };
  };
}
