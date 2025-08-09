{ config, pkgs, stable, unstable, ... }:
{
  imports = [ ];
  wsl.enable = true;
  wsl.defaultUser = "testme";
  time.timeZone = "America/New_York";
  console.font = "Fira Code Nerd Font";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with stable; [
    git
    starship
    neovim
    xclip
    wget
    curl
    bash
    libgcc
    libgccjit
    clang
    fd
    htop
    ripgrep
    bat
    gh
    unzip
    fish
    fzf
    smartcat
    eza
    lua
    luajit
    zed-editor
    deno 
    nushell

    unstable.cargo 
    unstable.uv
    (writeShellScriptBin "nixconf" ''
      nvim /etc/nixos/configuration.nix
    '')
    (writeShellScriptBin "backup" ''
      cp /etc/nixos/configuration.nix $HOME/dotfiles
    '')
    (writeShellScriptBin "rebuild" ''
      sudo nixos-rebuild switch
    '')
  ];
  environment.shells = with stable; [ bash nushell ];
  environment.shellInit = "nu";
  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    XDG_CONFIG_HOME = "$HOME/.config/";
    DOTFILES = "$HOME/dotfiles/";
  };
  environment.shellAliases = {
    ll = "ls -l";
    c = "clear";
    cat = "bat";
    grep = "rg";
    find = "fd";
    npm = "pnpm";
    v = "nvim";
  };
  programs.nix-ld.enable = true;
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "trunk";
      };
      user = {
        name = "TESTMECS";
        email = "axwar7410@gmail.com";
      };
    };
  };
  system.stateVersion = "24.11";
}
