{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation rec {
  pname = "neovim-dev";
  version = "unstable";

  src = pkgs.fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "master"; # latest dev branch
    sha256 = "sha256-8d154e5927d728cc2ad74a0dec8b45fab1333f8c";
  };

  nativeBuildInputs = [
    pkgs.cmake
    pkgs.pkg-config
    pkgs.gettext
    pkgs.libtool
    pkgs.autoconf
    pkgs.automake
    pkgs.gperf
  ];

  buildInputs = [
    pkgs.libuv
    pkgs.msgpack-c
    pkgs.luajit
    pkgs.unibilium
    pkgs.libtermkey
    pkgs.libvterm
    pkgs.tree-sitter
  ];

  configurePhase = ''
    cmake -B build -S . \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_INSTALL_PREFIX=$out
  '';

  buildPhase = ''
    cmake --build build
  '';

  installPhase = ''
    cmake --install build
  '';
}
