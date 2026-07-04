{ pkgs, ... }:

let
  all-grammars = pkgs.symlinkJoin {
    name = "nvim-all-grammars";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };
in
{
  programs.nix-ld.enable = true;
  system.userActivationScripts.linkTreesitter = {
    text = ''
      SRC_DIR="${all-grammars}/parser"
      TARGET_PARENT="/home/itai/.local/share/nvim/site"
      TARGET_LINK="$TARGET_PARENT/parser"

      mkdir -p "$TARGET_PARENT"
      rm -rf "$TARGET_LINK"
      ln -s "$SRC_DIR" "$TARGET_LINK"
      chown -R itai:users "$TARGET_PARENT"    


      QUERIES_SRC="${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}/runtime/queries"
      mkdir -p /home/itai/.local/share/nvim/site/queries
      rm -rf /home/itai/.local/share/nvim/site/queries
      ln -s "$QUERIES_SRC" /home/itai/.local/share/nvim/site/queries
    '';
  };

  environment.systemPackages = [
    all-grammars
    pkgs.tree-sitter

    (pkgs.neovim.override {
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;


      configure = {
        customRC = "
          set runtimepath^=${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}
        luafile ~/.config/nvim/init.lua";

        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            (nvim-treesitter.withAllGrammars)
          ];
        };
      };
    })

    pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    pkgs.gcc
    pkgs.gnumake
    pkgs.unzip
    pkgs.curl
    pkgs.tree-sitter
  ];
}
