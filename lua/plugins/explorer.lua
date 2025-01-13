return {
    -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Dependencia base de Telescope
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- Extensión FZF para búsquedas rápidas
        build = "make", -- Necesita compilarse con `make`
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git" },
        },
      })
      telescope.load_extension("fzf") -- Carga la extensión FZF
    end,
  },   

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- Configuración para NvimTree
    require("nvim-tree").setup({
      view = {
        width = 100, -- Ancho del árbol
        side = "left", -- Posición del árbol (izquierda)
        preserve_window_proportions = true, -- Mantener proporciones al dividir ventanas
      },
      renderer = {
        group_empty = true, -- Agrupar carpetas vacías
        indent_markers = {
          enable = true,
        }
      },
      actions = {
        open_file = {
          quit_on_open = false, -- No cerrar el árbol al abrir un archivo
        },
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Mapear teclas con WASD para navegación intuitiva
        vim.keymap.set("n", "<leader>w", api.node.navigate.parent, opts("Subir al directorio padre")) -- Subir un nivel
        vim.keymap.set("n", "s", api.node.navigate.sibling.next, opts("Siguiente archivo/carpeta")) -- Siguiente
        vim.keymap.set("n", "w", api.node.navigate.sibling.prev, opts("Archivo/carpeta anterior")) -- Anterior
        vim.keymap.set("n", "d", api.node.open.edit, opts("Abrir archivo/carpeta")) -- Abrir archivo o carpeta
        vim.keymap.set("n", "q", api.tree.close, opts("Cerrar árbol")) -- Cerrar el árbol
        vim.keymap.set("n", "a", api.fs.create, opts("Crear archivo/carpeta"))
      end,
    })
    end,
  },  

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Asegúrate de usar el nombre correcto del plugin
    config = function()
      require('lualine').setup {
        options = {
          theme = 'auto', -- Tema automático o cámbialo por otro que prefieras
          section_separators = '',
          component_separators = '|',
        },
        sections = {
          lualine_a = { 'mode' }, -- Modo actual (normal, insert, etc.)
          lualine_b = { 'branch' }, -- Rama de Git actual
          lualine_c = {
            { 'filename', path = 1 }, -- Muestra el nombre del archivo con su ruta relativa
            { function() return vim.fn.getcwd() end, icon = '' }, -- Muestra el directorio actual
          },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      }
    end,
  },
}