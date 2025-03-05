return {
	-- Fuzzy finder

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			-- Keep your existing Telescope setup
			telescope.setup({
				defaults = {
					file_ignore_patterns = { "node_modules", ".git" },
					mappings = {
						i = {
							["<C-i>"] = function(prompt_bufnr)
								local entry = action_state.get_selected_entry()
								actions.close(prompt_bufnr)

								-- Custom ignore logic
								local diagnostic = entry.value
								local bufnr = diagnostic.bufnr
								local lnum = diagnostic.lnum

								-- Get linter and code
								local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
								local linter = require("lint").linters_by_ft[ft][1]
								local code = diagnostic.code or diagnostic.message:match("%((%w+)%)") or ""

								-- Generate ignore comment
								local ignore_patterns = {
									eslint_d = "// eslint-disable-next-line %s",
									pylint = "# pylint: disable=%s",
									selene = "-- selene: allow(%s)",
									mypy = "# type: ignore[%s]",
									shellcheck = "# shellcheck disable=%s",
								}

								if linter and ignore_patterns[linter] then
									local ignore_line = string.format(ignore_patterns[linter], code)
									vim.api.nvim_buf_set_lines(bufnr, lnum, lnum, false, { ignore_line })
								end
							end,
						},
					},
				},
			})

			telescope.load_extension("fzf")

			-- New custom command for interactive ignoring
			vim.keymap.set("n", "<leader>li", function()
				require("telescope.builtin").diagnostics({
					attach_mappings = function(_, map)
						map("i", "<C-i>", actions.select_default)
						map("n", "<C-i>", actions.select_default)
						return true
					end,
				})
			end, { desc = "Selectively ignore diagnostics" })
		end,
	},

	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 100,
					side = "left",
				},
				renderer = {
					group_empty = true,
					icons = {
						webdev_colors = true,
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
						},
						glyphs = {
							default = "",
							symlink = "",
							folder = {
								default = "",
								open = "",
								empty = "",
								empty_open = "",
								symlink = "",
							},
							git = {
								unstaged = "✗",
								staged = "✓",
								unmerged = "",
								renamed = "➜",
								untracked = "★",
								deleted = "",
								ignored = "◌",
							},
						},
					},
				},
				actions = {
					open_file = {
						quit_on_open = false,
					},
				},
				on_attach = function(bufnr)
					local api = require("nvim-tree.api")
					local function opts(desc)
						return {
							desc = "nvim-tree: " .. desc,
							buffer = bufnr,
							noremap = true,
							silent = true,
							nowait = true,
						}
					end

					-- Navegación
					vim.keymap.set("n", "<leader>w", api.node.navigate.parent, opts("Subir al directorio padre"))
					vim.keymap.set("n", "s", api.node.navigate.sibling.next, opts("Siguiente archivo/carpeta"))
					vim.keymap.set("n", "w", api.node.navigate.sibling.prev, opts("Archivo/carpeta anterior"))
					vim.keymap.set("n", "d", api.node.open.edit, opts("Abrir archivo/carpeta"))
					vim.keymap.set("n", "q", api.tree.close, opts("Cerrar árbol"))

					-- Operaciones con archivos
					vim.keymap.set("n", "a", api.fs.create, opts("Crear archivo/carpeta"))
					vim.keymap.set("n", "x", api.fs.remove, opts("Borrar archivo/carpeta"))
					vim.keymap.set("n", "r", api.fs.rename, opts("Renombrar archivo/carpeta"))
					vim.keymap.set("n", "c", api.fs.copy.node, opts("Copiar archivo/carpeta"))
					vim.keymap.set("n", "p", api.fs.paste, opts("Pegar archivo/carpeta"))

					-- Expansión y colapso de carpetas
					vim.keymap.set("n", "E", api.tree.expand_all, opts("Expandir todo"))
					vim.keymap.set("n", "C", api.tree.collapse_all, opts("Colapsar todo"))

					-- Previsualización
					vim.keymap.set("n", "P", api.node.open.preview, opts("Previsualizar archivo"))

					-- Cambiar directorio raíz
					vim.keymap.set("n", "cd", api.tree.change_root_to_node, opts("Cambiar directorio raíz"))

					-- Abrir en nueva ventana o pestaña
					vim.keymap.set("n", "t", api.node.open.tab, opts("Abrir en nueva pestaña"))
					vim.keymap.set("n", "v", api.node.open.vertical, opts("Abrir en ventana vertical"))
					vim.keymap.set("n", "h", api.node.open.horizontal, opts("Abrir en ventana horizontal"))

					-- Refrescar árbol
					vim.keymap.set("n", "R", api.tree.reload, opts("Refrescar árbol"))

					-- Buscar archivos con Telescope
					-- Buscar archivos con Telescope
					vim.keymap.set("n", "<leader>ff", function()
						local node = api.tree.get_node_under_cursor()
						local path = node and node.absolute_path or api.tree.get_current_dir()
						require("telescope.builtin").find_files({ cwd = path })
					end, opts("Buscar archivos con Telescope"))

					-- Abrir terminal en el directorio actual
					vim.keymap.set("n", "<leader>tt", function()
						vim.cmd("terminal")
						vim.cmd("cd " .. api.tree.get_root().path)
					end, opts("Abrir terminal en directorio actual"))
				end,
			})
		end,
	},

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-web-devicons").setup({
				override = {},
				default = true, -- Habilitar íconos por defecto
			})

			require("lualine").setup({
				options = {
					theme = "auto", -- Tema automático o cámbialo por otro que prefieras
					section_separators = { left = "", right = "" }, -- Separadores bonitos
					component_separators = { left = "", right = "" }, -- Separadores para componentes
					icons_enabled = true, -- Habilitar íconos globalmente
				},
				sections = {
					lualine_a = { "mode" }, -- Modo actual (normal, insert, etc.)
					lualine_b = { { "branch", icon = "" }, "diff", "diagnostics" },
					lualine_c = {
						{ "filename", path = 1, symbols = { modified = " ●", readonly = " " } },
						{
							function()
								return vim.fn.getcwd()
							end,
							icon = "",
						}, -- Directorio actual
					},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
}
