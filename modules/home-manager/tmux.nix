{ config, ... }:

{
    programs.tmux = {
        enable = true;

        prefix = "C-s";

        clock24 = true;
        baseIndex = 1;
        escapeTime = 0;
        historyLimit = 50000;
        mouse = true;
        terminal = "screen-256color";

        customPaneNavigationAndResize = true;
        keyMode = "vi";

        extraConfig = ''
            # change title size
            set -g status-left-length 20

            # -n option means "without prefix"
            bind -n C-p previous-window
            bind -n C-n next-window
        '';
    };
}
