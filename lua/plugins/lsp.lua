return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Comentarios inteligentes
      { "numToStr/Comment.nvim" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },

      -- Linters y formateadores
      {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }
      },

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
      { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },

      -- 🔥 Auto-close tags & pairs
      { "windwp/nvim-ts-autotag" },
      { "windwp/nvim-autopairs" },

      -- 🔹 Mejoras para CSS
      { "bmatcuk/stylelint-lsp" }, -- Linter avanzado para CSS
      { "prettier/vim-prettier", run = "yarn install --frozen-lockfile --production" },
    },

    config = function()
      local lsp = require("lsp-zero").preset("recommended")

      local lspconfig = require('lspconfig')
      lspconfig.gopls.setup({
        setting = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
            },
        },
      })

      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      local on_attach = function(client, bufnr)
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>fb', function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end     -- Configuración adicional para servidores específicos
      lsp.configure("pylsp", {
        cmd = { "pylsp" }, -- Este comando debe coincidir con el ejecutable en tu PATH
        settings = {
          pylsp = {
            plugins = {
              -- Desactiva pycodestyle para evitar conflictos con Ruff
              pycodestyle = { enabled = true },
              flake8 = { enabled = true },
              -- Activa Ruff como el linter principal
              ruff = {
                enabled = true,
                extendSelect = { "I" }, -- Opcional: Agrega reglas adicionales, por ejemplo, convenciones de importación
              },
            },
          },
        },
      }) 
     lsp.configure("sqls", {
          settings = {
              sqls = {
                  connections = {
                     {
                        driver = 'mysql',
                        dataSourceName = 'rolo:Admin_123@tcp(127.0.0.1:3306)/hello_mysql',
                    },
                },
            },
        }
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

     lsp.configure("cssls", {
          settings = {
            css = { validate = true },
          }
      })
    
      lsp.configure("html", {
          settings = {},
      })
      -- 🔹 Configuración de nvim-autopairs
      local npairs = require("nvim-autopairs")
      npairs.setup({ check_ts = true, enable_check_bracket_line = true })

      -- Integrar nvim-autopairs con cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- 🔹 Configuración de null-ls para linters y formateadores
      local null_ls = require("null-ls")
      null_ls.setup({
           sources = {
            -- 🔹 Linters
            null_ls.builtins.diagnostics.eslint,  -- Linter para JS/TS
            null_ls.builtins.diagnostics.flake8,  -- Linter para Python
            null_ls.builtins.diagnostics.shellcheck, -- Linter para Shell Scripts
            null_ls.builtins.diagnostics.markdownlint, -- Linter para Markdown
            null_ls.builtins.diagnostics.stylelint, -- Linter para CSS, SCSS y Less

            -- 🔹 Formateadores (Opcional, si quieres que también formatee)
            null_ls.builtins.formatting.prettier, -- Para JS, TS, CSS, JSON, HTML
            null_ls.builtins.formatting.stylua, -- Para Lua
            null_ls.builtins.formatting.black, -- Para Python
            null_ls.builtins.formatting.shfmt, -- Para Bash
            null_ls.builtins.formatting.clang_format, -- Para C/C++
          },      
      })
 
      -- 🔹 Configuración de Treesitter
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 
          "lua", "python", "javascript", "typescript", "tsx", "html", "css",
          "json", "yaml", "bash", "markdown", "vim", "c", "cpp", "go"
        },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-backspace>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
          },
        },
        matchup = { enable = true },
        rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
        }
      })  
      -- 🔹 Configuración de ts_context_commentstring
      require('ts_context_commentstring').setup({
        enable_autocmd = false,
      })

      vim.g.skip_ts_context_commentstring_module = true -- Acelera la carga

      -- 🔹 Configuración de Comment.nvim
      require("Comment").setup({
        pre_hook = function(ctx)
          return require("ts_context_commentstring.internal").calculate_commentstring({
            key = ctx.ctype == require("Comment.utils").ctype.linewise and "__default"
              or "__multiline"
          })
        end,
      })

      -- 🔹 Configuración de nvim-ts-autotag
      require("nvim-ts-autotag").setup({
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      })

      -- 🔹 Configuración de nvim-cmp (Autocompletado)
      local cmp_mappings = lsp.defaults.cmp_mappings({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      })

      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      lsp.setup_nvim_cmp({
        mapping = cmp_mappings,
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "luasnip" },
          { name = "css" },
        },
      })

      -- 🔹 Finaliza la configuración
      lsp.on_attach(on_attach)
      lsp.setup()
    end,
  },
}
