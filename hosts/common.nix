{ config, pkgs, ... }:

{
  # Shared config here
  networking.firewall.enable = false;

  services.openssh.enable = true;

  users.users.drew = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    password = ""; # better to use hashedPassword or other auth
  };
}
