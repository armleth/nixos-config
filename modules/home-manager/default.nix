{ lib, config, pkgs, pkgsUnstable, root, ... }:

{
    home = {
        username = "armleth";
        homeDirectory = "/home/armleth";
    };

    home.packages = [
        pkgs.ripgrep
        pkgs.fzf
        pkgs.fd
        pkgs.slack
        pkgs.vscode
        pkgs.chromium
        pkgs.tmux
        pkgs.gnumake
        pkgs.gcc
        pkgs.criterion
        pkgs.clang-tools

        # gnome extensions from stable branch
        pkgs.gnomeExtensions.space-bar
        pkgs.gnomeExtensions.transparent-top-bar-adjustable-transparency
        pkgs.gnomeExtensions.no-titlebar-when-maximized
        pkgs.gnomeExtensions.privacy-settings-menu

        # gnome extensions from unstable branch - generally because of gnome version conflicts
        pkgsUnstable.gnomeExtensions.resource-monitor
    ];

    imports = [
        ./dconf.nix
        ./firefox.nix
        ./shell.nix
    ];

    programs = {
        git = {
            enable = true;
            userName = "Armleth";
            userEmail = "armand.thibaudon@epita.fr";
        };

        alacritty = {
            enable = true;
            settings = {
                shell.program = "${pkgs.fish}/bin/fish";
                font = {
                    size = 14;

                    normal.family = "MesloLGS NF";
                    bold.family = "MesloLGS NF";
                    italic.family = "MesloLGS NF";
                };
            };
        };

    };

    home.stateVersion = "24.05";

    programs.home-manager.enable = true;
}
