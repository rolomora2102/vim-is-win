return {
  -- Plugin principal: lsp-zero.nvim
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
    },
    config = function()
      local lsp = require("lsp-zero").preset("recommended")

      -- Configuración adicional para servidores específicos
      lsp.configure("pylsp", {
        cmd = { "pylsp" }, -- Este comando debe coincidir con el ejecutable en tu PATH
        settings = {
          pylsp = {
            plugins = {
              -- Desactiva pycodestyle para evitar conflictos con Ruff
              pycodestyle = { enabled = false },
              flake8 = { enabled = false },
              -- Activa Ruff como el linter principal
              ruff = {
                enabled = true,
                extendSelect = { "I" }, -- Opcional: Agrega reglas adicionales, por ejemplo, convenciones de importación
              },
            },
          },
        },
      }) 
      lsp.configure("ts_ls", {
        settings = {
          javascript = {
            suggest = {
              autoImports = true,
            },
          },
        },
      }) -- TypeScript/JavaScript

      -- Configuración para autocompletado
      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local cmp_mappings = lsp.defaults.cmp_mappings({
        ["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      })

      lsp.setup_nvim_cmp({
        mapping = cmp_mappings,
      })

      -- Función para ejecutar al adjuntar un servidor LSP
      lsp.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }

        -- Atajos básicos para LSP
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
      end)

      -- Finaliza la configuración
      lsp.setup()
    end,
  },
}
