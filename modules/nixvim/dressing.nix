{
  plugins.dressing = {
    enable = true;
    settings = {
      input = {
        enabled = true;
        default_prompt = "➤ ";
        select = {
          enabled = true;
          backend = [ "telescope" "builtin" ];
        };
      };
    };
  };
}
