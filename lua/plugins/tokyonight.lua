return {
  {
    "folke/tokyonight.nvim",
    lazy = false,          -- Cargar inmediatamente
    priority = 1000,       -- Alta prioridad para que se cargue primero
    opts = {
      style = "night",     -- Opciones: storm, moon, night, day
      transparent = false, -- Hacer el fondo transparente
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
      vim.cmd("highlight Normal guibg=#000000") -- Fondo de la ventana principal
      vim.cmd("highlight NormalNC guibg=#000000") -- Fondo de ventanas sin foco
      vim.cmd("highlight FloatBorder guibg=#000000 guifg=#505050") -- Bordes flotantes gris oscuro
      vim.cmd("highlight CursorLine guibg=#101010") -- Línea del cursor en gris oscuro
      vim.cmd("highlight CursorLineNr guifg=#FFFFFF guibg=#101010") -- Números resaltados
      vim.cmd("highlight VertSplit guifg=#101010 guibg=#000000")
    end,
  }  
}
