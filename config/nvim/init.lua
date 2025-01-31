local jetpackfile = vim.fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
local jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if vim.fn.filereadable(jetpackfile) == 0 then
  vim.fn.system(string.format('curl -fsSLo %s --create-dirs %s', jetpackfile, jetpackurl))
end

vim.cmd("packadd vim-jetpack")

require("jetpack.packer").add {
	{ "tani/vim-jetpack" },
	{ "folke/tokyonight.nvim" },
  {
    "neovim/nvim-lspconfig",
    events = "BufRead",
    config = function()
      local lspconfig = require("lspconfig")
      require("ddc_source_lsp_setup").setup{}

      lspconfig.denols.setup{}
      lspconfig.ts_ls.setup{}
      lspconfig.svelte.setup{}
      lspconfig.lua_ls.setup{}
      lspconfig.rust_analyzer.setup{}

      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "g[", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "g]", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "gn", vim.lsp.buf.rename, opts)
    end
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    config = function()
      require("lazydev").setup{}
    end
  },
  {
    "folke/flash.nvim",
    config = function()
      require("flash").setup{
        modes = {
          char = {
            keys = {}
          }
        }
      }
      vim.keymap.set({"n", "x", "o"}, "<Leader>f", function() require("flash").jump() end)
    end
  },
  {
    "folke/which-key.nvim",
    config = function()
      local which_key = require("which-key")
      vim.keymap.set("n", "<Leader>?", function() which_key.show({ global = false }) end)
    end
  },
  { "vim-denops/denops.vim" },

  {
    "Shougo/ddc.vim",
    config = function()
      vim.fn["ddc#custom#load_config"](vim.fn.expand("~/.config/nvim/ddc.ts"))
      vim.fn["ddc#enable"]()
    end
  },
  {
    "Shougo/pum.vim",
    config = function()
      vim.keymap.set("i", "<C-n>", [[<Cmd>call pum#map#select_relative(+1)<CR>]])
      vim.keymap.set("i", "<C-p>", [[<Cmd>call pum#map#select_relative(-1)<CR>]])
      vim.keymap.set("i", "<C-y>", [[<Cmd>call pum#map#confirm()<CR>]])
      vim.cmd [[
      inoremap <silent><expr> <CR> pum#visible() ? pum#map#confirm() :
        \ "\<Cmd>call feedkeys(v:lua.require('nvim-autopairs').autopairs_cr(), 'in')\<CR>"
      ]]
      vim.keymap.set("i", "<C-e>", function() vim.fn["pum#map#cancel"]() end)
    end
  },
  { "Shougo/ddc-ui-pum" },
  { "Shougo/ddc-source-around" },
  { "Shougo/ddc-source-lsp" },
  { "uga-rosa/ddc-source-lsp-setup" },
  { "tani/ddc-fuzzy" },

  {
    "Shougo/ddu.vim",
    config = function()
      vim.fn["ddu#custom#load_config"](vim.fn.expand("~/.config/nvim/ddu.ts"))
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ddu-ff",
        callback = function()
          local opts = { noremap = true, silent = true, buffer = true }
          vim.keymap.set("n", "q", [[<Cmd>call ddu#ui#do_action("quit")<CR>]], opts)
          vim.keymap.set("n", "i", [[<Cmd>call ddu#ui#do_action("openFilterWindow")<CR>]], opts)
          vim.keymap.set("n", "<CR>", [[<Cmd>call ddu#ui#do_action("itemAction")<CR>]], opts)
          vim.keymap.set("n", "p", [[<Cmd>call ddu#ui#do_action("preview")<CR>]], opts)
        end
      })

      vim.keymap.set("n", "<Leader><Leader>", [[<Cmd>call ddu#start(#{ name: "files" })<CR>]])
      vim.keymap.set("n", "<Leader>l", [[<Cmd>call ddu#start(#{ name: "lines" })<CR>]])
    end
  },
  { "Shougo/ddu-ui-ff" },
  { "Shougo/ddu-ui-filer" },
  { "Shougo/ddu-source-line" },
  { "Shougo/ddu-source-file_rec" },
  { "Shougo/ddu-filter-matcher_substring" },
  { "Shougo/ddu-kind-file" },
  {
    "windwp/nvim-autopairs",
    events = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup{}
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        highlight = {
          enable = true
        },
        indent = {
          enable = true,
        }
      }
    end
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup{}
    end
  },
  {
    "vim-skk/skkeleton",
    events = "InsertEnter",
    config = function()
      vim.cmd('call skkeleton#config({"globalDictionaries": ["~/.skk/SKK-JISYO.L"]})')
      vim.keymap.set("i", "<C-j>", "<Plug>(skkeleton-toggle)")
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function ()
      require("lualine").setup{}
    end
  }
}

vim.cmd[[colorscheme tokyonight]]

vim.g.mapleader = ' '
vim.opt.termguicolors = true

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.smartindent = true
vim.opt.showmatch = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.hlsearch = false

vim.opt.mouse = "a"

vim.opt.pumblend = 10
vim.opt.winblend = 10

vim.keymap.set("n", "ss", "<cmd>:split<CR>")
vim.keymap.set("n", "sv", "<cmd>:vsplit<CR>")
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sl", "<C-w>l")
vim.keymap.set("n", "sH", "<C-w>H")
vim.keymap.set("n", "sJ", "<C-w>J")
vim.keymap.set("n", "sK", "<C-w>K")
vim.keymap.set("n", "sL", "<C-w>L")
vim.keymap.set("n", "s>", "<C-w>>")
vim.keymap.set("n", "s<", "<C-w><")
vim.keymap.set("n", "s+", "<C-w>+")
vim.keymap.set("n", "s-", "<C-w>-")
vim.keymap.set("n", "sc", "<C-w>c")
