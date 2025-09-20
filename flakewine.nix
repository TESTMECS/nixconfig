{
  description = "Wine dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # adjust if needed
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.wineWowPackages.full  # full Wine with 32- and 64-bit support
          pkgs.winetricks            # optional helper
        ];
      };
    };
}
