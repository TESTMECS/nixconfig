{ config, pkgs, stable, unstable, ... }: {
  imports = [ ];
  wsl.enable = true;
  wsl.defaultUser = "testme";
  time.timeZone = "America/New_York";
  console.font = "Fira Code Nerd Font";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with stable; [
    git
    neovim
    xclip
    wget
    curl
    bash
    libgcc
    libgccjit
    clang
    fd
    ripgrep
    bat
    gh
    unzip
    fish
    fzf
    eza
    lua
    luajit
    deno
    nushell
    unstable.cargo
    unstable.uv
  ];
  environment.shells = with stable; [ bash fish nushell ];
  environment.shellInit = "fish";
  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    XDG_CONFIG_HOME = "$HOME/.config/";
    DOTFILES = "$HOME/dotfiles/";
  };
  programs.nix-ld.enable = true;
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
  system.stateVersion = "24.11";
}
