{ config, pkgs, ... }: {
	imports = [ ];
	environement.systemPackages = with pkgs; [
		# scripts
		(pkgs.writeShellScriptBin "testme_build" ''
			sudo nixos-rebuild switch --flake .#testme
		'')
		# apps
		(pkgs.writeShellApplication {
			name = "testme";
			runtimeInputs = with pkgs; [
				meow
			];
			text = ''meow'';
		 })
# Just
		(pkgs.writeShellApplication {
			name = "just";
			runtimeInputs = with pkgs; [
				just
			];
			text = ''just --list'';
		 })
	];
}
