{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation rec {
  pname = "neovim-dev";
  version = "unstable";

  src = pkgs.fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "master";
    sha256 =
      "0000000000000000000000000000000000000000000000000000"; # placeholder
    # Use `builtins.fetchGit` or `builtins.fetchTarball` or run `nix-prefetch-git` to get the real hash
  };

  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    pkg-config
    gettext
    unzip
    unzip
    curl
    unzip
    libtool
    automake
    autoconf
    make
    gcc
    luarocks
    lua
  ];

  buildInputs = with pkgs; [
    libuv
    libmsgpack
    libtermkey
    luv
    unibilium
    tree-sitter
    libvterm
  ];

  # Neovim build is CMake-based
  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DCMAKE_INSTALL_PREFIX=$out" ];

  # Neovim build phases
  buildPhase = ''
    mkdir build
    cd build
    cmake .. ${toString cmakeFlags}
    ninja
  '';

  installPhase = ''
    cd build
    ninja install
  '';

  meta = with pkgs.lib; {
    description = "Neovim development version (master branch)";
    homepage = "https://github.com/neovim/neovim";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
