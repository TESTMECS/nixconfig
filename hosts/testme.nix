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
		just
    ripgrep # better grep
    fd # better find
    bat # better cat/less
    fzf # better fuzzy find 
    eza # better ls
    procs # better ps
		dua # lua???
		unstable.rustup #rustup
    # === shell ===
		bash
		fish
    starship # better prompt
    # neovim
		neovim-nightly
	  # ===== Scripts ===== 
		(pkgs.writeShellScriptBin "testme-build" ''
			sudo nixos-rebuild switch --flake .#testme
		'')
		(pkgs.writeShellApplication {
			name = "testme";
			runtimeInputs = with pkgs; [
				meow
			];
			text = ''meow'';
		 })
  ];
  environment.shells = with stable; [ bash fish ];
  programs.nix-ld.enable = true;
  system.stateVersion = "24.11";
}
