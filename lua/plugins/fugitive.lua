return {
    {
      "tpope/vim-fugitive",
      lazy = true, -- Cargar solo cuando se use el keymap
      keys = {
        { "<leader>gs", ":Git<CR>", desc = "Abrir Fugitive (Git)" },
      },
      config = function()
        -- Configuración adicional si es necesaria (opcional)
        vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true, desc = "Git Commit" })
        vim.api.nvim_set_keymap("n", "<leader>gp", ":Git push<CR>", { noremap = true, silent = true, desc = "Git Push" })
      end,
    },
  }
  