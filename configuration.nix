{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 20;
    };

    supportedFilesystems = [ "ntfs" ];
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    htop
    neofetch
    gnome-tweaks
    dconf-editor
    discord
    wl-clipboard
    xsel
  ];

  fonts.packages = with pkgs; [
    meslo-lgs-nf
    nerd-fonts.jetbrains-mono
    nerd-fonts.inconsolata
  ];

  # Time zone.
  time.timeZone = "Europe/Paris";

  nixpkgs.config.allowUnfree = true;

  # Users
  # users.defaultUserShell = pkgs.fish;
  users.users = {
    root.shell = pkgs.fish;

    armleth = {
      isNormalUser = true;
      home = "/home/armleth";
      shell = pkgs.fish;
      description = "Armleth";
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "vboxusers"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFx1yMiV7vpOQxKzzwLMShkl2qj55OUuEy/BHuiyQjas armleth@ArmlethArch"
      ];
    };
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
      };

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;
    };

    gnome = {
      gnome-keyring.enable = true;
      # gnome-browser-connector.enable = true;
    };

    displayManager.autoLogin = {
      enable = true;
      user = "armleth";
    };

    pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    pulseaudio.enable = false;

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "yes";
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    cheese
    gnome-music
    yelp
    gnome-contacts
    gnome-initial-setup
  ];

  programs = {
    zsh.enable = true;
    fish.enable = true;
    dconf.enable = true;
    direnv.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Better audio quality
  services.pipewire.wireplumber.extraConfig = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [
        "hsp_hs"
        "hsp_ag"
        "hfp_hf"
        "hfp_ag"
      ];
    };
  };

  # Workaround to make gmd autologin work
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  system.stateVersion = "24.05"; # Dont change - represents the first installed NixOS version
}
