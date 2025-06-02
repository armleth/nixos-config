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
    ./tmux.nix
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
        texliveFull
        calibre
        nixd
        neovim
        jetbrains.idea-ultimate
        # jdk21_headless
        jdk17_headless
        bat
        yaml-cpp
        cmake
        vlc
        eza
        mongodb-ce
        direnv
        pyright
        jetbrains.pycharm-professional
        jetbrains.datagrip
        typescript-language-server
        python312Full
        dwt1-shell-color-scripts
        nodejs
        nixfmt-rfc-style

        # Gnome extensions from stable branch
        gnomeExtensions.space-bar
        gnomeExtensions.transparent-top-bar-adjustable-transparency
        gnomeExtensions.no-titlebar-when-maximized
        gnomeExtensions.privacy-settings-menu
        gnomeExtensions.bluetooth-battery-meter
      ])
      ++ (with pkgsUnstable; [
        # Gnome extensions from unstable branch - generally because of gnome version conflicts
        gnomeExtensions.resource-monitor
      ]);
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "default-web-browser" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "application/pdf" = "org.gnome.Evince.desktop";
    };
  };

  programs = {
    java = {
      package = pkgs.jdk17_headless;
      enable = true;
    };

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
