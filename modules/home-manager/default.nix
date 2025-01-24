{
  lib,
  config,
  pkgs,
  pkgsUnstable,
  root,
  ...
}:

{
  imports = [
    ./dconf.nix
    ./firefox.nix
    ./shell.nix
  ];

  home = {
    username = "armleth";
    homeDirectory = "/home/armleth";

    packages =
      (with pkgs; [
        ripgrep
        fzf
        fd
        slack
        vscode
        chromium
        tmux
        gnumake
        gcc
        criterion
        clang-tools
        neofetch
        lua-language-server
        nil
        texliveFull
        calibre
        nixd
        neovim

        # Gnome extensions from stable branch
        gnomeExtensions.space-bar
        gnomeExtensions.transparent-top-bar-adjustable-transparency
        gnomeExtensions.no-titlebar-when-maximized
        gnomeExtensions.privacy-settings-menu
      ])
      ++ (with pkgsUnstable; [
        # Gnome extensions from unstable branch - generally because of gnome version conflicts
        gnomeExtensions.resource-monitor
      ]);
  };

  programs = {
    git = {
      enable = true;
      userName = "Armleth";
      userEmail = "armand.thibaudon@epita.fr";
    };

    alacritty = {
      enable = true;
      settings = {
        terminal.shell.program = "${pkgs.fish}/bin/fish";
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
