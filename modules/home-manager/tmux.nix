{ config, pkgs, ... }:

{
    programs.tmux = {
        enable = true;

        prefix = "C-s";

        clock24 = true;
        baseIndex = 1;
        escapeTime = 0;
        historyLimit = 50000;
        mouse = true;
        terminal = "tmux-256color";
        shell = "${pkgs.fish}/bin/fish";

        customPaneNavigationAndResize = true;
        keyMode = "vi";

        extraConfig = ''
            # change title size
            set -g status-left-length 20

            set-option -a terminal-features 'alacritty:RGB'
        '';
    };
}
