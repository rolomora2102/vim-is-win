return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
          "mfussenegger/nvim-dap-python",
        },
        config = function()
          local dap_python = require("dap-python")
          dap_python.setup("~/.virtualenvs/debugpy/bin/python") -- Ruta al Python debugger
          dap_python.test_runner = "pytest"
        end,
      },
      {
      'kristijanhusak/vim-dadbod-ui',
      dependencies = {
        { 'tpope/vim-dadbod', lazy = true },
        { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
      },
      cmd = {
        'DBUI',
        'DBUIToggle',
        'DBUIAddConnection',
        'DBUIFindBuffer',
      },        
      config = function()
          -- Opciones opcionales de configuración
          vim.g.db_ui_save_location = '~/.config/nvim/sql_dbs'
        end
      },
      {
        "CRAG666/code_runner.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
          require("code_runner").setup({
            mode = "term",
            focus = true,
            filetype = {
              python = "python3 -u",
            },
          })
        end,
      },
  -- Plenary.nvim as a dependency
  { "nvim-lua/plenary.nvim" },
}
