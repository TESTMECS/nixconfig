{ config, pkgs, stable, unstable, ... }: {
  imports = [ ];
  wsl.enable = true;
  wsl.defaultUser = "testme";
  time.timeZone = "America/New_York";
  console.font = "Fira Code Nerd Font";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with stable; [
    # === shell ===
    git
    bash
    xclip
    libgcc
    libgccjit
    clang
    curl
    wget
    ripgrep
    fd
    bat
    gh
    unzip
    fzf
    # === shell ===
    fish
    starship
    # === neovim ===
    neovim
    lua
    luajit
    # === Web ===
    nodejs
    deno
    pnpm
    unstable.nushell
    unstable.cargo
    unstable.uv
  ];
  environment.shells = with stable; [ bash fish nushell ];
  programs.nix-ld.enable = true;
  system.stateVersion = "24.11";
}
