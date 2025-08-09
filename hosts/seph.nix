{ config, pkgs, ... }:
let
  unstableTarball = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
  };
  unstable = import unstableTarball {
    system = pkgs.system;
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];
  # ===
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # === 
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
    #media-session.enable = true;
  };
  users.users.seph = {
    isNormalUser = true;
    description = "drew";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "seph";
  nixpkgs.config.allowUnfree = true;
  # === Default Environment ===
  environment.systemPackages = with pkgs; [
    # === Apps ===
    unstable.neovim
    obsidian
    nushell
    wget
    wezterm
  ];
  environment.shells = with pkgs; [ bash nushell ];
  environment.shellInit = "nu";
  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    XDG_CONFIG_HOME = "~/.config";
    DOTFILES = "~/dotfiles";
  };
  environment.shellAliases = {
    c = "clear";
    v = "nvim";
  };
  # === Programs ===
  programs.firefox.enable = true;
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "trunk";
      };
      user = {
        name = "TESTMECS";
        email = "axwar7410@gmail.com";
      };
    };
  };
  # === Services ===
  services.openssh.enable = true;
  system.stateVersion = "25.05";
}
