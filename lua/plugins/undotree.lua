return {
    {
      "mbbill/undotree",
      lazy = true, -- Cargar solo cuando se use el keymap
      keys = {
        { "<leader>u", ":UndotreeToggle<CR>", desc = "Abrir Undotree" },
      },
      config = function()
        -- Configuración adicional si la necesitas
        vim.g.undotree_WindowLayout = 2 -- Ajustar el layout (opcional)
      end,
    },
  }
  