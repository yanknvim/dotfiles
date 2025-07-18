vim.lsp.enable("rust_analyzer")
vim.lsp.enable("denols")
vim.lsp.enable("lua_ls")
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
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "enable completion",
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        local bufnr = ev.buf

        local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
        client.server_capabilities.completionProvider.triggerCharacters = chars

        vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
        })
    end
})
