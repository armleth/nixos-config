# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    imports = [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
        git
        neovim
        htop
        neofetch
        gnome.gnome-tweaks
        gnome.dconf-editor
    ];

    fonts.packages = with pkgs; [
        meslo-lgs-nf
        (nerdfonts.override { fonts = ["JetBrainsMono" "Inconsolata"]; })
    ];

    # Time zone.
    time.timeZone = "Europe/Paris";

    # Users
    users.users.armleth = {
        isNormalUser = true;
        home = "/home/armleth";
        description = "Armleth";
        extraGroups = ["wheel" "networkmanager"];
    };

    # Enable the X11 windowing system.
    services = {
        xserver = {
            enable = true;
            xkb = {
                layout = "us";
                options = "caps:escape";
            };

            displayManager.gdm = {
                enable = true;
                wayland = true;
            };
            desktopManager.gnome.enable = true;
        };

        gnome.gnome-keyring.enable = true;
    };
    
    programs.dconf.enable = true;

    environment.gnome.excludePackages = (with pkgs; [
            gnome-photos
            gnome-tour
    ]) ++ (with pkgs.gnome; [
        cheese
        gnome-music
        yelp
        gnome-contacts
        gnome-initial-setup
    ]);

    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

# Enable sound.
# hardware.pulseaudio.enable = true;
# OR
# services.pipewire = {
#   enable = true;
#   pulse.enable = true;
# };

# Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

    system.stateVersion = "24.05"; # Dont change - represents the first installed NixOS version

}

