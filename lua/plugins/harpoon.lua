return {
    -- Harpoon for quick file navigation
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup()
      local map = vim.keymap.set
      map("n", "<leader>a", function() require("harpoon.mark").add_file() end, { desc = "Añadir archivo a Harpoon" })
      map("n", "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end, { desc = "Abrir menú de Harpoon" })
      map("n", "<leader>1", function() require("harpoon.ui").nav_file(1) end, { desc = "Ir al archivo 1" })
      map("n", "<leader>2", function() require("harpoon.ui").nav_file(2) end, { desc = "Ir al archivo 2" })
      map("n", "<leader>3", function() require("harpoon.ui").nav_file(3) end, { desc = "Ir al archivo 3" })
      map("n", "<leader>4", function() require("harpoon.ui").nav_file(4) end, { desc = "Ir al archivo 4" })
    end,
  },
}