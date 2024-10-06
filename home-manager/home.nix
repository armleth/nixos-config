{ lib, config, pkgs, ... }:

{
    home = {
        username = "armleth";
        homeDirectory = "/home/armleth";
    };

    home.packages = with pkgs; [
        neofetch
        ripgrep
    ];

    xsession.windowManager.i3 = rec {
        enable = true;
        package = pkgs.i3-gaps;
        
        config = 
        let
            modifier = "Mod4";
        in
        {
            inherit modifier;
            keybindings = lib.mkOptionDefault {
                "${modifier}+Return" = "exec alacritty";
            };
        };
    };

    # Git configuration
    programs.git = {
        enable = true;
        userName = "Armleth";
        userEmail = "armand.thibaudon@gmail.com";
    };

    programs.bash = {
        enable = true;
        shellAliases = {
            rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/.";
            vim = "nvim";
        };
    };

    home.stateVersion = "24.05";

    programs.home-manager.enable = true;
}
