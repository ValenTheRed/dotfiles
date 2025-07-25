return {
	-- {{{ psmdc.nvim
	{
		"ValenTheRed/psmdc.nvim",
		config = function()
			-- require("psmdc").setup {
			-- 	transparent_bg = true
			-- }
			vim.cmd.colorscheme("psmdc_dark")
		end,
		priority = 1000,
		branch = "master",
		-- dir = "~/repository/psmdc.nvim",
		-- dev = true,
	}, -- }}}
	"tpope/vim-commentary",
	"tpope/vim-fugitive",
	"tpope/vim-surround",
	"tpope/vim-repeat",
	"tpope/vim-dispatch",
	"danro/rename.vim",
	"godlygeek/tabular",
	"Vimjas/vim-python-pep8-indent",
	"wlangstroth/vim-racket",
	"nvim-tree/nvim-web-devicons",
	-- {{{ oil.nvm
	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup {
				default_file_explorer = true,
				buf_options = {
					buflisted = false,
					bufhidden = "hide",
				},
				columns = {
					"icon",
				},
				keymaps = {
					["<C-s>"] = false,
					["<C-h>"] = false,
					["<C-t>"] = false,
					["<C-p>"] = false,
					["<C-c>"] = false,
					["<C-l>"] = false,
					["<C-p>"] = "actions.select_vsplit",
					["<C-s>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-a>"] = "actions.preview",
					["<C-q>"] = "actions.close",
					["<C-r>"] = "actions.refresh",
				},
			}
		end,
	}, -- }}}
	-- {{{ nvim-colorizer.lua
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	}, -- }}}
	-- {{{ indent-blankline.nvim
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup {
				indent = { char = "│" },
				scope = { enabled = false },
			}
		end,
	}, -- }}}
	--{{{ nvim-ts-autotag
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup {
				opt = {
					enable = true,
					enable_rename = true,
					enable_close = false,
					enable_close_on_slash = false,
				}
			}
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	}, --}}}
	--{{{ nvim-treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			local lang_list = {
				'jsx', 'tsx', 'javascript', 'typescript', 'python', 'go'
			}
			require('nvim-treesitter').install(lang_list)
			vim.api.nvim_create_autocmd('FileType', {
				pattern = lang_list,
				callback = function()
					-- syntax highlighting, provided by Neovim
					vim.treesitter.start()
					-- folds, provided by Neovim
					vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
					-- indentation, provided by nvim-treesitter
					vim.bo.indentexpr =
					"v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
		lazy = false,
		dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
		branch = "main",
		build = ":TSUpdate",
	}, --}}}
	-- {{{ L3MON4D3/LuaSnip
	-- GUIDE: https://www.ejmastnak.com/tutorials/vim-latex/luasnip/
	{
		"L3MON4D3/LuaSnip",
		config = function()
			local ls = require("luasnip")
			ls.setup {
				enable_autosnippets = true,
			}
			ls.filetype_extend("typescriptreact", { "typescript" })
			vim.keymap.set({ "i", "s" }, "<C-L>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-h>", function()
				ls.jump(-1)
			end, { silent = true })
		end,
	}, -- }}}
	-- {{{ LunarWatcher/auto-pairs
	{
		"LunarWatcher/auto-pairs",
		config = function()
			vim.g.AutoPairsPrefix = "<M-x>"
			vim.g.AutoPairsMapBS = true
			vim.g.AutoPairsMultilineBackspace = true
			vim.g.AutoPairs = vim.fn["autopairs#AutoPairsDefine"] {
				-- NOTE: the closing pair is not inserted when inserting the
				-- opening pair using digraph. This may be because inserting
				-- digraph is just a just special case of i_CTRL-V. See `:h
				-- digraph`, `:h autopairs-troubleshooting-general`, and
				-- `:h i_CTRL-V`.
				--
				-- However, the above limitation is only for insertion, not for
				-- deletion.
				{ open = "“", close = "”" },
				{ open = "‘", close = "’" },
			}
		end,
	}, -- }}}
	"mfussenegger/nvim-jdtls",
}
-- vim: set fdm=marker fdl=0:
