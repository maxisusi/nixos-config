{ pkgs, ... }:
let
  jsFiletypes = [
    "javascript"
    "javascriptreact"
    "typescript"
    "typescriptreact"
  ];
in
{
  extraPackages = with pkgs; [
    oxlint
    oxfmt
  ];

  plugins.lint = {
    enable = true;
    lintersByFt = builtins.listToAttrs (
      map (ft: {
        name = ft;
        value = [ "oxlint" ];
      }) jsFiletypes
    );
  };

  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = builtins.listToAttrs (
        map (ft: {
          name = ft;
          value = [ "oxfmt" ];
        }) jsFiletypes
      );
      format_on_save = {
        timeout_ms = 1000;
        lsp_format = "never";
      };
    };
  };
}
