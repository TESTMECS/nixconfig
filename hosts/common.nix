{ config, pkgs, ... }:
{
  imports = [ ];
  environment.shellAliases = {
    ll = "eza -l";
    l = "eza -l";
    la = "eza -la";
		br = "broot";
		ps = "procs";
    cat = "bat";
    grep = "rg";
    find = "fd";
    npm = "pnpm";
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
programs.fish.enable = true;
  programs.bash.completion.enable = true;
  networking.firewall.enable = false;
  services.openssh.enable = true;
}
