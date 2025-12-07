{
  lib,
  config,
  pkgs,
  pkgsUnstable,
  root,
  ...
}:

let
  jetbrainsApps = with pkgs.jetbrains; [
    pycharm-professional
    idea-ultimate
    datagrip
  ];

  # This code modifies the .desktop files of JetBrains applications by adding the
  # JVM option `-Dawt.toolkit.name=WLToolkit` to the Exec command.
  # On Wayland, this fixes focus and input issues with Java AWT/Swing applications.
  #
  # See:
  #     - https://blog.jetbrains.com/platform/2024/07/wayland-support-preview-in-2024-2/
  #     - https://www.reddit.com/r/NixOS/comments/1hr293i/how_to_properly_handle_desktop_files_with/
  jetbrainsDesktopMods = map (
    jetbrainsApp:
    (lib.hiPrio (
      pkgs.runCommand "${jetbrainsApp.pname}-desktop-modify" { } ''
        mkdir -p $out/share/applications
        substitute ${jetbrainsApp}/share/applications/${jetbrainsApp.pname}.desktop \
            $out/share/applications/${jetbrainsApp.pname}.desktop \
            --replace-fail "Exec=${jetbrainsApp.pname}" "Exec=${jetbrainsApp.pname} -Dawt.toolkit.name=WLToolkit"
      ''
    ))
  ) jetbrainsApps;

  jetbrainsAppsAndDesktopMods = jetbrainsApps ++ jetbrainsDesktopMods;

in
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
      (
        with pkgs;
        [
          # Basic unix tools
          bat
          eza
          fd
          fzf
          neofetch
          ripgrep

          # Apps
          calibre
          chromium
          slack
          vlc
          filezilla
          teamviewer
          musescore

          # Editor
          dwt1-shell-color-scripts
          neovim
          tmux
          vscode

          # Dev packages
          clang-tools
          cmake
          criterion
          gcc
          gnumake
          jdk17_headless
          lua-language-server
          nixd
          nixfmt-rfc-style
          verible
          nodejs
          pyright
          python312
          texliveFull
          typescript-language-server
          yaml-cpp
          vscode-langservers-extracted
          kubectl
          sqlfluff

          # To mount afs from home
          sshfs
          krb5
        ]
        ++ jetbrainsAppsAndDesktopMods
        ++ (with gnomeExtensions; [
          bluetooth-battery-meter
          launch-new-instance
          no-titlebar-when-maximized
          privacy-settings-menu
          space-bar
          transparent-top-bar-adjustable-transparency
          resource-monitor
        ])
      )
      ++ (with pkgsUnstable; [ ]);
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
      "application/pdf" = "org.gnome.papers.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
    };
  };

  programs = {
    java = {
      package = pkgs.jdk17_headless;
      enable = true;
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "Armleth";
          email = "armand.thibaudon@epita.fr";
        };
      };
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
