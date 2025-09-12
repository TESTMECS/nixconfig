{
  description = "Multi-host NixOS configuration example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-25.05";
		neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }@inputs: {
    nixosConfigurations = {
      seph = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/common.nix ./hosts/seph.nix ];
      };

      testme = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/testme.nix
					./hosts/common.nix
          nixos-wsl.nixosModules.default
        ];
        specialArgs = {
          stable = inputs."nixpkgs-stable".legacyPackages.x86_64-linux;
          unstable = nixpkgs.legacyPackages.x86_64-linux;
					neovim-overlay = inputs."neovim-nightly-overlay".packages.default;
        };
      };
    };
  };
}
