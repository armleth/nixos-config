{ lib, config, pkgs, ... }:

{
    home = {
        username = "armleth";
        homeDirectory = "/home/armleth";
    };

    home.packages = with pkgs; [
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

    programs = {
        git = {
            enable = true;
            userName = "Armleth";
            userEmail = "armand.thibaudon@gmail.com";
        };

        # bash = {
        #     enable = true;
        #     shellAliases = {
        #         rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/.";
        #         vim = "nvim";
        #     };
        # };

        alacritty = {
            enable = true;
            settings = {
                shell.program = "${pkgs.zsh}/bin/zsh";
                font = {
                    normal.family = "MesloLGS NF";
                    bold.family = "MesloLGS NF";
                    italic.family = "MesloLGS NF";
                };
            };
        };

        zsh = {
            enable = true;
            # initExtra = ''
            #     [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
            # '';
            shellAliases = {
                rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config/.";
                vim = "nvim";
            };
            plugins = [
            {
                name = "powerlevel10k";
                src = pkgs.zsh-powerlevel10k;
                file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
            {
                name = "powerlevel10k-config";
                src = lib.cleanSource ./p10k-config;
                file = "p10k.zsh";
            }
            ];
            # zplug = {
            #     enable = true;
            #     plugins = [
            #     { name = "zsh-users/zsh-autosuggestions"; }
            #     { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
            #     ];
            # };
        };
    };

    home.stateVersion = "24.05";

    programs.home-manager.enable = true;
}
