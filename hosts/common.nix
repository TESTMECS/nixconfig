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
  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    XDG_CONFIG_HOME = "$HOME/.config/";
  };
  programs.git = {
    enable = true;
    config = {
      init = { defaultBranch = "trunk"; };
      user = {
        name = "TESTMECS";
        email = "axwar7410@gmail.com";
      };
    };
  };
  environment.shellInit = "fish";
  networking.firewall.enable = false;
  services.openssh.enable = true;
}
