{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      useOSProber = true;
    };
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "Nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # xserver settings
  services.xserver = {
    layout = "no";
    xkbVariant = "winkeys";
    enable = true;
    
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
  
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  
  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Configure console keymap
  console.keyMap = "no";

  # Define a user account
  users.users.xcom = {
    isNormalUser = true;
    description = "xcom";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Setting ZSH as shell
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  users.users.xcom.shell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Experimental features
  nix.settings.experimental-features = [ "nix-command"  "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    neofetch
    hyprland
    xwayland
    gnome.gdm
    gnome.gnome-keyring
    git
    kitty
    pavucontrol
    blueman
    nfs-utils
    qemu
  ];

  # Programs
  programs = {
    thunar.enable = true;
    dconf.enable = true;
  };

  # PulseAudio
  sound.enable = true;

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Systemd
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

  system.stateVersion = "23.11"; 
}
