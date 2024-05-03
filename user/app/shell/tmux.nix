{ pkgs, config, lib, ...}:
{
  programs.tmux = {
    enable = true;

    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";

    clock24 = true;
    shortcut = "Space";
    baseIndex = 1;
    newSession = true;

    escapeTime = 0;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.urlview
      tmuxPlugins.sidebar
      tmuxPlugins.sensible
      
    ];

    keyMode = "vi";

    aggressiveResize = true;

    extraConfig = lib.strings.fileContents ./tmux-extra.conf;
  };
}
