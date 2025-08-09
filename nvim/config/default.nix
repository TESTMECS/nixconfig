{ config, pkgs, ... }:
{
  imports = [
    ./keymaps.nix
    ./options.nix
    ./plugins.nix
  ];

}
