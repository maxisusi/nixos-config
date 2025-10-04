{ config, lib, pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      height = "40%";
      width = "40%";
      location = 2; # center
      yoffset = 300;
      hide_scroll = true;
      insensitive = true;
      matching = "fuzzy";
      mode = "drun";
      prompt = "";
      term = "kitty";
      line_wrap = "word";
      single_click = true;
    };
    style = ''
      * {
        font-family: "${config.stylix.fonts.monospace.name}";
        font-size: 14px;
      }

      window {
        margin: 1px;
        border: 2px solid #${config.lib.stylix.colors.base0D};
        border-radius: 10px;
        background-color: #${config.lib.stylix.colors.base00};
      }

      #input {
        margin: 8px;
        padding: 8px;
        border-radius: 6px;
        border: 1px solid #${config.lib.stylix.colors.base02};
        background-color: #${config.lib.stylix.colors.base01};
        color: #${config.lib.stylix.colors.base05};
        font-size: 16px;
      }

      #input:focus {
        border-color: #${config.lib.stylix.colors.base0D};
        outline: none;
      }

      #inner-box {
        margin: 5px;
        background-color: #${config.lib.stylix.colors.base00};
        border-radius: 8px;
      }

      #outer-box {
        margin: 3px;
        padding: 15px;
        background-color: #${config.lib.stylix.colors.base00};
        border-radius: 10px;
      }

      #scroll {
        margin: 5px;
      }

      #text {
        margin: 8px;
        padding: 4px;
        color: #${config.lib.stylix.colors.base05};
      }

      #entry {
        padding: 8px;
        margin: 2px;
        border-radius: 6px;
        transition: all 0.2s ease;
      }

      #entry:hover {
        background-color: #${config.lib.stylix.colors.base02};
      }

      #entry:selected {
        background-color: #${config.lib.stylix.colors.base0D};
        border-radius: 6px;
      }

      #entry:selected #text {
        color: #${config.lib.stylix.colors.base00};
        font-weight: bold;
      }

      #img {
        margin-right: 10px;
      }
    '';
  };
}