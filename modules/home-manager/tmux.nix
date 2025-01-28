{ config, ... }:

programs.tmux = {
    enable = true;
    clock24 = true;
    defaultKeyMode = "vi";
    baseIndex = 1;
    prefix = 'C-s';
}

