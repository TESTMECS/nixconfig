{ config, pkgs, stable, unstable, neovim-nightly, ... }: {
  wsl.enable = true;
  time.timeZone = "America/New_York";
  console.font = "Fira Code Nerd Font";
  i18n.defaultLocale = "en_US.UTF-8";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with stable; [
    # === shell ===
    git
    gh
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
    procs
    dua
		unstable.cargo
		unstable.rustup
    # === shell ===
		bash
		nushell
    starship
    # neovim
		neovim-nightly
    # === Web ===
    bun
    pnpm
		# === Python ===
		uv
  ];
  environment.shells = with stable; [ bash nushell ];
  programs.nix-ld.enable = true;
  system.stateVersion = "24.11";
}
