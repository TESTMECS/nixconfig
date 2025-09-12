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
    gh
    bash
    xclip
    clang
    curl
    wget
    unzip
    # === Rust ===
    ripgrep
    fd
    bat
    fzf
    broot
    eza
    jujutsu
    just
    procs
    dua
    # === shell ===
    fish
    starship
    # === neovim ===
    neovim
    # === Web ===
    bun
    pnpm
    unstable.cargo # for new projects
  ];
  environment.shells = with stable; [ bash fish ];
  programs.nix-ld.enable = true;
  system.stateVersion = "24.11";
}
