{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./grub.nix
    ./x11.nix
  ];

  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Singapore/Singapore";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    rxvt_unicode
    tmux
    git
    firefox
    elinks
    cmus
    mplayer
    i3status
    dmenu
    hsetroot
    transmission_gtk
    gcc5
    llvm
    clang
    gnumake
    automake
    cmake
    lua
    unzip
    leiningen
  ];

  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Font
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts # MS free fonts
      inconsolata # Monospaced
      terminus_font # The best
      unifont # Some international fonts
    ];
  };

  # Zsh
  programs.zsh.enable = true;

  users.extraUsers.jeaye = {
    isNormalUser = true;
    home = "/home/jeaye";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = "/run/current-system/sw/bin/zsh";
    uid = 1000;
  };

  system.stateVersion = "15.09";
}
