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

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Workaround to make gmd autologin work
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;

    system.stateVersion = "24.05"; # Dont change - represents the first installed NixOS version

}

