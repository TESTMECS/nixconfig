{ config, pkgs, stable, unstable, neovim-nightly,... }: {
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
		fish
    starship
    # neovim
		neovim-nightly
    # === Web ===
    bun
    pnpm
		# === Python ===
		uv
    # 
	  # ===== Scripts ===== 
		(pkgs.writeShellScriptBin "testme_build" ''
			sudo nixos-rebuild switch --flake .#testme
		'')
		(pkgs.writeShellApplication {
			name = "testme";
			runtimeInputs = with pkgs; [
				meow
			];
			text = ''meow'';
		 })
		(pkgs.writeShellApplication {
			name = "just";
			runtimeInputs = with pkgs; [
				just
			];
			text = ''just --list'';
		 })
  ];
  environment.shells = with stable; [ bash fish ];
  programs.nix-ld.enable = true;
  system.stateVersion = "24.11";
}
