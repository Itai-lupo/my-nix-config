{ pkgs, ... }:

{
  home.packages = [
    pkgs.ripgrep
  ];

  programs.nixvim = {
    enable = true;

    # Theme
    #    colorschemes.tokyonight.enable = true;

    # Settings
    opts = {
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      number = true;
      relativenumber = true;
      clipboard = "unnamedplus";
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 5;
    };

    keymaps = [
      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<leader>fs";
      }
      {
        action = "<cmd>NvimTreeToggle<CR>";
        key = "<leader>e";
      }
      {
        action = "<cmd>Telescope find_files<CR>";
        key = "<leader>ff";
      }
      {
        action = "<cmd>Man <C-r><C-w> <CR>";
        key = "<leader>g";
      }

    ];

    highlight = {
      Comment.fg = "#ff00ff";
      Comment.bg = "#000000";
      Comment.underline = true;
      Comment.bold = true;
    };

    globals.mapleader = " ";

    plugins = {

      # UI
      lualine.enable = true;
      bufferline.enable = true;
      treesitter.enable = true;
      oil = {
        enable = true;
      };

      which-key = {
        enable = true;
        registrations = {
          "<leader>fg" = "Find Git files with telescope";
          "<leader>fw" = "Find text with telescope";
          "<leader>ff" = "Find files with telescope";
        };
      };

      telescope = {
        enable = true;
        settings.keymaps = {
          "<leader>ff" = {
            desc = "file finder";
            action = "find_files";
          };
          "<leader>fg" = {
            desc = "find via grep";
            action = "live_grep";
          };
        };
        extensions = {
          file-browser.enable = true;
          fzf-native = {
            enable = true;
          };
        };
      };
      nix = {
        enable = true;
      };

      undotree = {
        enable = true;

      };

      nvim-tree = {
        enable = true;
        openOnSetup = true;
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
      };

      none-ls = {
        enable = true;
        cmd = [ "bash -c nvim" ];
        debug = true;
        sources = {
          code_actions = {
            statix.enable = true;
            gitsigns.enable = true;
          };
          diagnostics = {
            statix.enable = true;
            deadnix.enable = true;
            pylint.enable = true;
            checkstyle.enable = true;
          };
          formatting = {
            alejandra.enable = true;
            stylua.enable = true;
            shfmt.enable = true;
            nixpkgs_fmt.enable = true;
            google_java_format.enable = false;
            prettier = {
              enable = true;
              disableTsServerFormatter = true;
            };
            black = {
              enable = true;
              withArgs = ''
                {
                  extra_args = { "--fast" },
                }
              '';

            };
          };
          completion = {
            luasnip.enable = true;
            spell.enable = true;
          };
        };
      };
      lint = {
        enable = true;
        lintersByFt = {
          text = [ "vale" ];
          json = [ "jsonlint" ];
          markdown = [ "vale" ];
          rst = [ "vale" ];
          ruby = [ "ruby" ];
          janet = [ "janet" ];
          inko = [ "inko" ];
          clojure = [ "clj-kondo" ];
          dockerfile = [ "hadolint" ];
          terraform = [ "tflint" ];
        };
      };

      # Trouble
      trouble = {
        enable = true;
      };
      luasnip = {
        enable = true;
        #extraConfig = {
        #  enable_autosnippets = true;
        #  store_selection_keys = "<Tab>";
        #};
      };

      # Easily toggle comments
      comment = {
        enable = true;
        settings.sticky = true;
      };
      # Dev
      lsp = {
        enable = true;
        servers = {
          hls.enable = true;
          clangd.enable = true;
          marksman.enable = true;
          nil_ls.enable = true;
          lua-ls = {
            enable = true;
            settings.telemetry.enable = false;
          };
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };
      alpha = {
        enable = true;
        theme = "dashboard";
        iconsEnabled = true;
      };


      cmp-nvim-lsp = {
        enable = true; # Enable suggestions for LSP
      };
      cmp-buffer = {
        enable = true; # Enable suggestions for buffer in current file
      };
      cmp-path = {
        enable = true; # Enable suggestions for file system paths
      };
      cmp_luasnip = {
        enable = true; # Enable suggestions for code snippets
      };
      cmp-cmdline = {
        enable = false; # Enable autocomplete for command line
      };

    };

    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = comment-nvim;
        config = "lua require(\"Comment\").setup()";
      }
    ];

  };
}
