{ config, pkgs, ... }:

{

  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  # Bootloader
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
  };
  
  # Setting hostname & networkmanager
  networking = {
    hostName = "Nix";
    networkmanager.enable = true;
  };

  # edit as per your location and timezone
  time.timeZone = "Europe/Oslo";
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "no";

  # Enabling sound
  sound.enable = true;

  # xserver
  services.xserver = {
      layout = "no";
      xkbVariant = "winkeys";
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Setting users
  users.users.xcom = {
    isNormalUser = true;
    description = "xcom";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    hyprland
    hyprpaper
    waybar
    xwayland
    gnome.gdm
    git
    gnome.gnome-keyring
    networkmanagerapplet
    vim
    unrar
    unzip
    firefox
    kitty
  ];

  programs = {
    thunar.enable = true;
    dconf.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  
  hardware = {
    bluetooth.enable = true;
  };

  # Don't touch this
  system.stateVersion = "23.05";
}
