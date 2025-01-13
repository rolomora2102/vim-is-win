return {
    {
      "folke/tokyonight.nvim",
      lazy = false,          -- Cargar inmediatamente
      priority = 1000,       -- Alta prioridad para que se cargue primero
      opts = {
        style = "storm",     -- Opciones: storm, moon, night, day
        transparent = true, -- Hacer el fondo transparente
        terminal_colors = true, -- Usar colores del tema en el terminal integrado
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = { bold = true },
          variables = {},
        },
        sidebars = { "qf", "help" }, -- Fondos personalizados en barras laterales como :help
      },
      config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd([[colorscheme tokyonight]]) -- Aplicar el esquema de colores
      end,
    },
  }
  