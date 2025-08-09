{ config, pkgs, ... }:

{
  imports = [ ];
  environment.shellAliases = {
    ll = "ls -l";
    c = "clear";
    cat = "bat";
    grep = "rg";
    find = "fd";
    npm = "pnpm";
    v = "nvim";
  };
  # Shared config here
  networking.firewall.enable = false;

  services.openssh.enable = true;

  users.users.drew = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    password = ""; # better to use hashedPassword or other auth
  };
}
