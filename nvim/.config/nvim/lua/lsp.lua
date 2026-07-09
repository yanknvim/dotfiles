vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig"
})

-- from https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
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
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          '?.lua',
          '?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,

        library = {
          vim.env.VIMRUNTIME,
          -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
          vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library',
          -- '${3rd}/busted/library',
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = vim.api.nvim_get_runtime_file('', true),
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

