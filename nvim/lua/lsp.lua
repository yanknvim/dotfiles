vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig"
})

vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          '?.lua',
          '?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
        },
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

vim.lsp.enable("rust_analyzer")
vim.lsp.enable("lua_ls")
vim.lsp.enable("nil_ls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("elmls")
vim.lsp.enable("pyright")
vim.lsp.enable("racket_langserver")
vim.lsp.enable("clojure_lsp")
vim.lsp.enable("clangd")
vim.lsp.enable("zls")
vim.lsp.enable("tinymist")

vim.o.pumborder = "rounded"
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy', 'popup' }

vim.diagnostic.config {
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}

