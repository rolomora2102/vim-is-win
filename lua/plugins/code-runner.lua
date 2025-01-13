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