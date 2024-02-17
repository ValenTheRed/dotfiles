local nmap = function(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, {
		noremap = true,
		silent = true,
		desc = desc,
	})
end

local config = function()
	local actions = require("telescope.actions")

	local defaults = {
		-- defaults doesn't support the key, defining it inside of a theme
		-- works.
		--results_title = false
		selection_caret = "▌",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			width = 0.95,
			height = 0.85,
			prompt_position = "top",
			preview_width = function(_, cols, _)
				if cols > 200 then
					return math.floor(cols * 0.4)
				else
					return math.floor(cols * 0.6)
				end
			end,
		},
		border = true,
		vimgrep_arguments = vim.split(vim.opt.grepprg:get(), " "),
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-e>"] = require("telescope.actions.layout").toggle_preview,
			},
		},
	}

	require("telescope").setup {
		defaults = defaults,
		pickers = {
			buffers = {
				mappings = {
					i = {
						["<DEL>"] = actions.delete_buffer,
					},
					n = {
						["dd"] = actions.delete_buffer,
					},
				},
			},
		},
	}

	require("telescope").load_extension("fzf")

	-- KEYMAPS
	local builtin = require("telescope.builtin")

	-- ff mnemonic for: nothing, ff is in a convenient position
	nmap("<leader>ff", function()
		builtin.buffers {
			previewer = false,
			shorten_path = false,
		}
	end, "Telescope lists open buffers in current neovim instance")

	nmap(
		"<leader>fd",
		function()
			builtin.find_files {
				previewer = false,
				find_command = vim.split(
					[[fd --type file --hidden --exclude .git]],
					" "
				),
			}
		end,
		"Telescope lists files in your current working directory, respects .gitignore"
	)

	-- fg mnemonic for: file grep
	nmap(
		"<leader>fg",
		builtin.live_grep,
		"Telescope search for string in CWD with live results; respects .gitignore"
	)

	-- fm mnemonic for: file most recently used
	nmap("<leader>fm", function()
		builtin.oldfiles {
			previewer = false,
		}
	end, "Telescope lists previously open files")

	nmap(
		"<leader>fc",
		function()
			builtin.colorscheme {
				enable_preview = true,
			}
		end,
		"Telescope lists and previews available colorschemes; applies them on <cr>"
	)
end

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = config,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = ":make",
		dependencies = { "nvim-telescope/telescope.nvim" },
	},
}
