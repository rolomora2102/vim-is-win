-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configuración de Lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Importa solo módulos de plugins
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- Configuración general
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.syntax = "on"
vim.opt.lazyredraw = true

vim.o.autoindent = true -- Activa la autoindentación
vim.o.smartindent = true -- Activa la indentación inteligente-
-- Configuración de backups y swap
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Borrar una línea con Backspace en modo normal
vim.api.nvim_set_keymap('n', '<BS>', 'd', { noremap = true, silent = true })
-- Borrar la selección en modo visual
vim.api.nvim_set_keymap('v', '<BS>', 'd', { noremap = true, silent = true })



-- Movimiento básico con WASD
vim.api.nvim_set_keymap('n', 'w', 'k', { noremap = true, silent = true }) -- Arriba
vim.api.nvim_set_keymap('n', 's', 'j', { noremap = true, silent = true }) -- Abajo
vim.api.nvim_set_keymap('n', 'a', 'b', { noremap = true, silent = true }) -- Izquierda
vim.api.nvim_set_keymap('n', 'd', 'w', { noremap = true, silent = true }) -- Derecha
vim.api.nvim_set_keymap('n', 'A', '[{', { noremap = true, silent = true }) -- Saltar al bloque de código anterior
vim.api.nvim_set_keymap('n', 'D', ']}', { noremap = true, silent = true }) -- Saltar al bloque de código siguientegit a


-- Movimiento visual con WASD
vim.api.nvim_set_keymap('v', 'w', 'k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 's', 'j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'a', 'h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'd', 'l', { noremap = true, silent = true })

-- Selección visual con Leader + WASD
vim.api.nvim_set_keymap('n', '<leader>w', 'v<Up>', { noremap = true, silent = true }) -- Selección hacia arriba
vim.api.nvim_set_keymap('n', '<leader>s', 'v<Down>', { noremap = true, silent = true }) -- Selección hacia abajo
vim.api.nvim_set_keymap('n', '<leader>a', 'v0', { noremap = true, silent = true }) -- Selección al inicio de la línea
vim.api.nvim_set_keymap('n', '<leader>d', 'v$', { noremap = true, silent = true }) -- Selección al final de la línea


-- Movimiento en terminal con WASD
vim.api.nvim_set_keymap('t', '<C-w>', '<C-\\><C-n>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-s>', '<C-\\><C-n>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-a>', '<C-\\><C-n>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-d>', '<C-\\><C-n>l', { noremap = true, silent = true })


vim.api.nvim_set_keymap('n', '<leader>w', '<C-u>', { noremap = true, silent = true }) -- Scroll arriba
vim.api.nvim_set_keymap('n', '<leader>s', '<C-d>', { noremap = true, silent = true }) -- Scroll abajo

vim.api.nvim_set_keymap('n', '<leader>w', '<C-w>k', { noremap = true, silent = true }) -- Arriba
vim.api.nvim_set_keymap('n', '<leader>s', '<C-w>j', { noremap = true, silent = true }) -- Abajo
vim.api.nvim_set_keymap('n', '<leader>a', '<C-w>h', { noremap = true, silent = true }) -- Izquierda
vim.api.nvim_set_keymap('n', '<leader>d', '<C-w>l', { noremap = true, silent = true }) -- Derecha




-- NvimTree
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fc', ':Telescope commands<CR>', { noremap = true, silent = true })

-- Harpoon
vim.api.nvim_set_keymap('n', '<leader>a', ':lua require("harpoon.mark").add_file()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>1', ':lua require("harpoon.ui").nav_file(1)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>2', ':lua require("harpoon.ui").nav_file(2)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>3', ':lua require("harpoon.ui").nav_file(3)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>4', ':lua require("harpoon.ui").nav_file(4)<CR>', { noremap = true, silent = true })

-- Buffers
vim.api.nvim_set_keymap('n', '<leader>q', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bp', ':bprev<CR>', { noremap = true, silent = true })

-- Splits
vim.api.nvim_set_keymap('n', '<leader>sh', ':split<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sv', ':vsplit<CR>', { noremap = true, silent = true })

-- Alternar entre buffers
vim.api.nvim_set_keymap('n', '<leader><Tab>', '<C-^>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fr', ':Telescope oldfiles<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>t', ':split | terminal<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>v', ':vsplit | terminal<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<F5>", ":RunCode<CR>", { noremap = true, silent = true })

-- Seleccionar todo con Ctrl + A
vim.api.nvim_set_keymap('n', '<C-a>', 'ggVG', { noremap = true, silent = true }) -- Selecciona todo el archivo

-- Borrar hasta el final de la línea con Leader + D
vim.api.nvim_set_keymap('n', '<leader>D', 'd$', { noremap = true, silent = true })

-- Borrar hasta el inicio de la línea con Leader + A
vim.api.nvim_set_keymap('n', '<leader>A', 'd0', { noremap = true, silent = true })


-- Leader + D para borrar hasta el final de la línea
vim.api.nvim_set_keymap('n', '<leader>D', 'd$', { noremap = true, silent = true })

-- Leader + A para borrar hasta el inicio de la línea
vim.api.nvim_set_keymap('n', '<leader>A', 'd0', { noremap = true, silent = true })
