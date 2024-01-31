local letg = vim.g
local set = vim.opt

--{{{ Vim options

letg.mapleader = ","

-- use true colours; for nvim-colorizer.lua
set.termguicolors = true

-- allow mouse
set.mouse = { n = true, v = true, i = true }

-- Set the order of file encodings when reading and creating files.
set.fileencodings = { "utf-8" }

--Set the order of line endings when reading and creating files.
set.fileformats = { "unix", "dos", "mac" }

-- number column
set.number = true
set.relativenumber = true

-- always convert `tab` into spaces
set.expandtab = true
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4

-- Ignore case unless capital letters present in search
set.ignorecase = true
set.smartcase = true

set.wildignore:append {
	"*/tmp/*",
	"*/virenvs/*",
	"*/venvs/*",
	"*/.venv/*",
	"*.so",
	"*.swp",
	"*.zip",
}

-- hightlight current line
set.cursorline = true

-- delay changing from insert to normal mode in lightline reduced
set.ttimeout = true

-- fold along indent
set.foldmethod = "indent"
set.foldlevelstart = 99 -- don't start fold when file is opened

-- change signcolumn to accomodate signs
set.signcolumn = "auto"

-- time -- in ms -- after which swap file will be written
set.updatetime = 1000

-- for the popup menu in insert mode
set.completeopt = { "menuone", "noselect" }

-- NOTE: make sure to set the colour of the colour column wiht the colourscheme
set.colorcolumn = "79"

set.matchpairs:append("<:>")

set.fillchars:append("diff:╱")

set.splitright = true
set.splitbelow = true

-- use undo files. Undo directory set sensibly by default
set.undofile = true

-- inc/dec works with alphabets
set.nrformats:append("alpha")

-- save window sizes with :mks
set.sessionoptions:append { "resize", "winpos" }

-- Patience is better than the default in some cases.
-- Explanation of indent-heuristic:
-- https://vimways.org/2018/the-power-of-diff/#the-indent-heuristics
set.diffopt:append {
	"algorithm:patience",
	"indent-heuristic",
	"linematch:60",
	"foldcolumn:1",
}

if vim.fn.executable("rg") then
	-- Surrounding `!.git` with quotes makes :grep not work :( for unknown
	-- reasons.
	set.grepprg =
		[[rg --no-config --smart-case --hidden --glob !.git --trim --vimgrep]]
	set.grepformat:prepend("%f:%l:%c:%m")
end

set.linebreak = true

--}}}

-- {{{ Plugins

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	}
end
set.runtimepath:prepend(lazypath)

-- load ./lua/ps/plugins
-- colorscheme is set there
-- all plugins configuration is set there
require("lazy").setup("ps.plugins")

require("ps.sessions")
require("ps.wiki")
-- diagnostic is an neovim module
require("ps.vim_diagnostic")
require("ps.ui_input")
require("ps.prettierrc")
vim.cmd.packadd("cfilter")
require("luasnip.loaders.from_lua").load {
	paths = "./luasnip",
}

letg.tex_flavor = "latex"

-- }}}

-- {{{ Autocmds

-- Re-source $MYVIMRC if changed
-- augroup resource_vimrc
--     au!
--     autocmd BufWritePost $MYVIMRC nested :source $MYVIMRC
-- augroup END
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("re_source_vimrc", { clear = true }),
	pattern = vim.fn.expand("$MYVIMRC"),
	nested = true,
	command = ":source $MYVIMRC",
})

vim.api.nvim_create_autocmd("BufNewFile", {
	group = vim.api.nvim_create_augroup(
		"load_from_skeleton_file",
		{ clear = true }
	),
	pattern = "*",
	callback = function()
		local extension = vim.fn.expand("%:e")
		if extension == "" then
			return
		end
		-- To restore alternate file register after `:r` clobers it
		local alt_reg = vim.fn.getreg("#")
		local file = vim.fn.stdpath("config")
			.. [[/templates/skeleton.]]
			.. extension
		if vim.fn.filereadable(file) ~= 0 then
			vim.cmd([[0r ]] .. file)
		end
		vim.fn.setreg("#", alt_reg)
	end,
})

-- from :help incsearch
-- TODO: preserve `hlsearch`: on -> '/' on -> on; off -> '/' on -> off
-- augroup vimrc_incsearch_highlight
--     autocmd!
--     autocmd CmdlineEnter /,\? :set hlsearch
-- -- autocmd CmdlineLeave /,\? :set nohlsearch
-- augroup END
vim.api.nvim_create_autocmd("CmdlineEnter", {
	group = vim.api.nvim_create_augroup(
		"vimrc_incsearch_highlight",
		{ clear = true }
	),
	pattern = [[/,\?]],
	command = ":set hlsearch",
})

-- augroup remove_trailing_whitespaces
--     au!
--     autocmd BufWritePre * :%s/\s\+$//e
-- augroup END
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup(
		"remove_trailing_whitespaces",
		{ clear = true }
	),
	pattern = "*",
	callback = function()
		local view = vim.fn.winsaveview()
		vim.cmd("silent! undojoin")
		vim.cmd([[silent keepjumps keeppatterns %s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})

-- }}}

-- {{{ Functions

close_all_floating_windows = function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			vim.api.nvim_win_close(win, false)
			-- print('Closing window', win)
		end
	end
end

-- }}}

local nmap = function(...)
	vim.keymap.set("n", ...)
end
local vmap = function(...)
	vim.keymap.set("v", ...)
end
local imap = function(...)
	vim.keymap.set("i", ...)
end
local cmap = function(...)
	vim.keymap.set("c", ...)
end
local tmap = function(...)
	vim.keymap.set("t", ...)
end

-- {{{ Keymaps

-- 10j moves down by 10 lines while j moves by gj
local mux_with_g = function(key)
	local gkey = "g" .. key
	return function()
		if vim.v.count == 0 then
			return gkey
		else
			return key
		end
	end
end
nmap("j", mux_with_g("j"), { expr = true })
nmap("k", mux_with_g("k"), { expr = true })
vmap("j", mux_with_g("j"), { expr = true })
vmap("k", mux_with_g("k"), { expr = true })

-- remap Ex mode. We can still enter it using `gQ`
nmap("Q", "q:")

cmap("<C-k>", "<Up>")
cmap("<C-j>", "<Down>")

-- Yank till EOF; consistency with 'D', 'C' etc.
nmap("Y", "y$")

-- Toggle search hightlighting
nmap("<F3>", ":set hlsearch! hlsearch?<CR>")

-- Search and Replace word and WORD under the cursor throughout the buffer
nmap("<Leader>r", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]])
nmap("<Leader>R", [[:%s/\<<C-r><C-A>\>//g<Left><Left>]])
-- Search using a word boundary
vmap("<Leader>r", [["*y:%s/\V<C-r><S-*>//g<Left><Left>]])
-- search using no word boundry
vmap("<Leader>R", [["*y:%s/\V<C-r><S-*>//g<Left><Left>]])

-- Break lines at cursor
nmap("<leader><CR>", "i<CR><ESC>", { silent = true })

-- Copy/pasting from system clipboard
nmap("<M-p>", [["+]p]])
vmap("<M-y>", [["+y]])
imap("<M-p>", [[<ESC>"+]pa]])

-- Buffer
nmap("]b", ":bn<CR>")
nmap("[b", ":bp<CR>")

-- change directory for whole of nvim
nmap("<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { silent = true })
nmap("<leader>lc", ":lcd %:p:h<CR>:pwd<CR>", { silent = true })
-- change directory for the current window

-- We can emulate 'zoom' feature by opening the buffer in a new tab.
-- builtin keymap is <C-W><C-T>

-- Easy move between split panes
nmap("<C-j>", "<C-w><C-j>")
nmap("<C-k>", "<C-w><C-k>")
nmap("<C-h>", "<C-w><C-h>")
nmap("<C-l>", "<C-w><C-l>")

tmap("<ESC>", [[<C-\><C-n>]])

-- :sp and :vs are easier to type than :vne and :new so, remap their shortcuts
nmap("<C-w><C-v>", ":vne<Cr>", { silent = true })
nmap("<C-w><C-s>", ":new<Cr>", { silent = true })

-- Easy resize of split panes
nmap("<M-j>", "<C-w><C-->")
nmap("<M-k>", "<C-w><C-+>")
nmap("<M-l>", "<C-w><C->>")
nmap("<M-h>", "<C-w><C-<>")

nmap("<leader>erc", ":e $MYVIMRC<CR>")
nmap("<leader>grc", ":e $MYGVIMRC<CR>")

-- }}}

-- vim: set fdm=marker fdl=0:
