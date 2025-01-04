return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true, -- Automatically install configured language servers
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Helper function for on_attach
      local function on_attach(_, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end

      -- Configure language servers
      local servers = {
        tsserver = {},
        solargraph = {},
        html = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } }, -- Avoid 'undefined global' warnings for vim workspace = { checkThirdParty = false },
            },
          },
        },
      }

      for server, config in pairs(servers) do
        lspconfig[server].setup(vim.tbl_extend("force", {
          capabilities = capabilities,
          on_attach = on_attach,
        }, config))
      end
    end,
  },
}

