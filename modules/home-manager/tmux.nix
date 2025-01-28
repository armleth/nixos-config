{ config, ... }:

{
    programs.tmux = {
        enable = true;
        clock24 = true;
        defaultKeyMode = "vi";
        baseIndex = 1;
        escapeTime = 0;
        prefix = "C-s";
        historyLimit = 50000;

        extraConfig = ''
            bind C-p previous-window
            bind C-n next-window
        '';
    };
}
