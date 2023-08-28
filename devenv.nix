{ pkgs, ... }:

# See full reference at https://devenv.sh/reference/options/

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    lua-language-server
    shellcheck
    stylua
  ];

  # https://devenv.sh/languages/
  languages.lua = {
    enable = true;
    package = pkgs.lua5_1;
  };

  pre-commit.hooks = {
    luacheck.enable = true;
    shellcheck.enable = true;
    stylua.enable = true;
  };
}
