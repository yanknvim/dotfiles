{ config, lib, pkgs, inputs, ... }:

let
  skkeleton = pkgs.vimUtils.buildVimPlugin {
    name = "skkeleton";
    src = inputs.skkeleton;
  };
  flix-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "flix-nvim";
    src = inputs.flix-nvim;
  };
  veryl-vim = pkgs.vimUtils.buildVimPlugin {
    name = "veryl-vim";
    src = inputs.veryl-vim;
  };
in
{
  programs.nixvim = {
    enable = true;

    colorscheme = "rose-pine";

    luaLoader.enable = true;

    performance.byteCompileLua.enable = true;

    # =========================================================================
    # Basic settings (core.lua migration)
    # =========================================================================
    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };

    opts = {
      pumblend = 15;
      pumborder = "rounded";
      number = true;
      cursorline = true;

      autoindent = true;
      smartindent = true;
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = true;

      showmatch = true;

      hlsearch = true;
      incsearch = true;
      ignorecase = true;
      smartcase = true;
      wildmenu = true;

      backup = false;
      writebackup = false;
      swapfile = false;

      termguicolors = true;
      cmdheight = 0;
      laststatus = 0;
      statusline = "─";

      completeopt = [ "menu" "menuone" "noselect" "fuzzy" "popup" ];
    };

    diagnostic.settings = {
      jump = {
        on_jump.__raw = ''function(_, bufnr)
          vim.diagnostic.open_float { bufnr = bufnr, scope = "cursor", focus = false }
        end'';
      };
    };

    extraConfigLua = ''
      vim.opt.fillchars:append({ stl = "─", stlnc = "─" })

      -- Snacks setup
      require("snacks").setup {
        indent = {
          enabled = true,
          animate = {
            enabled = false
          }
        },
        picker = {
          enabled = true,
          layout = {
            layout = {
              backdrop = false,
            }
          }
        },
        explorer = {
          enabled = true,
        },
      }

      -- Incline setup
      local helpers = require("incline.helpers")
      local devicons = require("nvim-web-devicons")
      require("incline").setup {
        window = {
          padding = 0,
          margin = { horizontal = 0 },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          return {
            ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
            " ",
            { filename, gui = modified and "bold,italic" or "bold" },
            " ",
            guibg = "#44406e",
          }
        end,
      }

      -- Reactive setup (deferred to reduce startup time)
      vim.defer_fn(function()
        require("reactive").setup {
          builtin = {
            cursorline = true,
            cursor = true,
          },
        }
      end, 100)

      -- Flix LSP setup
      vim.lsp.config("flix", {
        cmd = { "flix", "lsp" },
      })
      vim.lsp.enable("flix")

      -- Skkeleton setup (InsertEnter)
      vim.api.nvim_create_autocmd("InsertEnter", {
        group = vim.api.nvim_create_augroup("skkeleton", { clear = true }),
        once = true,
        callback = function()
          vim.fn["denops#plugin#discover"]()
          vim.fn["skkeleton#config"]({
            globalDictionaries = { "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L" },
            eggLikeNewline = true,
          })
        end,
      })
    '';

    # =========================================================================
    # Filetype-specific settings (ftplugin/ migration)
    # =========================================================================
    autoCmd = [
      {
        event = "FileType";
        pattern = [ "javascript" "javascriptreact" "typescript" "typescriptreact" ];
        callback.__raw = ''function()
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
          vim.opt_local.softtabstop = 2
        end'';
      }
      {
        event = "FileType";
        pattern = [ "nix" ];
        callback.__raw = ''function()
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
        end'';
      }
    ];

    # =========================================================================
    # LSP settings (lsp.lua migration)
    # =========================================================================
    plugins.lsp = {
      enable = true;
      servers = {
        lua_ls = {
          enable = true;
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT";
                path = [ "?.lua" "?/init.lua" ];
              };
              workspace = {
                checkThirdParty = false;
                library = [ "${pkgs.neovim}/share/nvim/runtime/lua" ];
              };
            };
          };
        };
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        nil_ls.enable = true;
        ts_ls.enable = true;
        elmls.enable = true;
        pyright.enable = true;
        racket_langserver = {
          enable = true;
          package = null;
        };
        clojure_lsp.enable = true;
        clangd.enable = true;
        zls.enable = true;
        tinymist.enable = true;
        veryl_ls = {
          enable = true;
          cmd = [ "veryl-ls" ];
        };
      };
    };

    # =========================================================================
    # Keymaps
    # =========================================================================
    keymaps = [
      # Snacks picker keymaps
      {
        mode = "n";
        key = "<Leader>fb";
        action.__raw = ''function() Snacks.picker.buffer() end'';
        options.desc = "Find buffer";
      }
      {
        mode = "n";
        key = "<Leader>ff";
        action.__raw = ''function() Snacks.picker.git_files() end'';
        options.desc = "Find file (git)";
      }
      {
        mode = "n";
        key = "<Leader>fg";
        action.__raw = ''function() Snacks.picker.grep() end'';
        options.desc = "Grep";
      }
      {
        mode = "n";
        key = "<Leader>fk";
        action.__raw = ''function() Snacks.picker.keymaps() end'';
        options.desc = "Find keymaps";
      }
      {
        mode = "n";
        key = "<Leader><Leader>";
        action.__raw = ''function() Snacks.explorer.open() end'';
        options.desc = "Explorer";
      }
      # Which-key
      {
        mode = "n";
        key = "<Leader>?";
        action.__raw = ''function() require("which-key").show {} end'';
        options.desc = "Show keymaps";
      }
      # Flash
      {
        mode = [ "n" "x" "o" ];
        key = "s";
        action.__raw = ''function() require("flash").jump {} end'';
        options.desc = "Flash jump";
      }
      # Skkeleton
      {
        mode = [ "i" "c" ];
        key = "<C-j>";
        action = "<Plug>(skkeleton-enable)";
        options = {
          noremap = false;
          desc = "Enable skkeleton";
        };
      }
    ];

    # =========================================================================
    # Nixvim native plugins
    # =========================================================================
    plugins = {
      lz-n = {
        enable = true;
      };

      blink-cmp = {
        enable = true;
        setupLspCapabilities = false;
        lazyLoad.settings.event = [ "InsertEnter" ];
        settings = {
          keymap = { preset = "default"; };
          sources = {
            default = [ "lsp" "path" "snippets" "buffer" ];
          };
        };
      };

      flash = {
        enable = true;
        lazyLoad.settings.keys = [ "s" ];
      };

      gitsigns = {
        enable = true;
        settings = {};
      };

      which-key = {
        enable = true;
        settings = {};
      };

      treesitter = {
        enable = true;
        settings = {};
      };

      nvim-autopairs = {
        enable = true;
        settings = {};
      };

      web-devicons = {
        enable = true;
        settings = {};
      };

      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            char = "│";
          };
        };
      };
    };

    # =========================================================================
    # Extra plugins (nixpkgs available but no nixvim module + from flake inputs)
    # =========================================================================
    extraPlugins = with pkgs.vimPlugins; [
      denops-vim
      conjure
      vim-sexp
      vim-sexp-mappings-for-regular-people
      nvim-parinfer
      incline-nvim
      snacks-nvim
      reactive-nvim
      rose-pine
    ] ++ [
      skkeleton
      flix-nvim
      veryl-vim
    ];

    # =========================================================================
    # Extra packages (LSP servers, formatters, etc.)
    # =========================================================================
    extraPackages = with pkgs; [
      lua-language-server
      nil
      typescript-language-server
      elmPackages.elm-language-server
      pyright
      racket
      clojure-lsp
      clang-tools
      zls
      tinymist
      ripgrep
      veryl
    ];
  };
}
