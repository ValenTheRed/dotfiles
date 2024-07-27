local set = vim.opt
local lsp_progress = require("lsp-progress")

local use_winbar = true

local statusline = { active = {}, inactive = {} }
local winbar = {}

-- remove dafault components
for _, v in ipairs { "a", "b", "c", "x", "y", "z" } do
	local section = string.format("lualine_%s", v)
	statusline.active[section] = {}
	statusline.inactive[section] = {}
end

local winwidth = vim.fn.winwidth

-- Insert component at section {a, b, c, x, y, z}
local function insert(section, component)
	local section = string.format("lualine_%s", section)
	table.insert(statusline.active[section], component)
end

-- FileInfo consists of [buftype icon][space][file path][space][file status flags]
local FileInfo = {}

FileInfo.icon = function(type)
	local buftypes = {
		file = { full = "", outline = "" },
		terminal = { full = "", outline = "" },
		oil = { full = "", outline = "" },
		netrw = { full = "󰡰", outline = "󰲁" }, -- "󰒍"
		help = { full = "󰠩", outline = "󰠩" },
		checkhealth = { full = "󱙣", outline = "󱙤" }, -- "" "♥"
		nofile = { full = "", outline = "" },
	}
	return function()
		local filetype = vim.bo.filetype
		local icon = buftypes.file
		if filetype == "netrw" then
			icon = buftypes.netrw
		elseif filetype == "oil" then
			icon = buftypes.oil
		elseif filetype == "help" then
			icon = buftypes.help
		elseif filetype == "checkhealth" then
			icon = buftypes.checkhealth
		elseif vim.bo.buftype == "terminal" then
			icon = buftypes.terminal
		elseif vim.bo.buftype == "nofile" then
			icon = buftypes.nofile
		end
		return icon[type]
	end
end

FileInfo.path = function()
	local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
	if filename == "" then
		return "[No Name]"
	end
	return "%<" .. filename
end

FileInfo.component = function(icon_type)
	return {
		{
			FileInfo.icon(icon_type),
			padding = 1,
		},
		{
			FileInfo.path,
			padding = { right = 1 },
		},
		{
			function()
				return "[+]"
			end,
			padding = { right = 1 },
			cond = function()
				return vim.bo.modified
			end,
		},
		{
			function()
				return ({ full = "󱆠", outline = "󱆡" })[icon_type]
			end,
			padding = { right = 1 },
			cond = function()
				return vim.bo.readonly
			end,
		},
		{
			function()
				return ({ full = "", outline = "" })[icon_type]
			end,
			padding = { right = 1 },
			cond = function()
				return not vim.bo.modifiable
			end,
		},
	}
end

if use_winbar then
	winbar.active = {
		lualine_a = {
			unpack(FileInfo.component("full")),
		},
		lualine_c = {
			{
				function()
					return ""
				end,
				color = "Normal",
				draw_empty = true,
			},
		},
	}
	winbar.inactive = {
		lualine_a = {
			unpack(FileInfo.component("outline")),
		},
		lualine_b = {
			{
				function()
					return ""
				end,
				draw_empty = true,
			},
		},
	}
	insert("a", {
		function()
			return " "
		end,
		padding = {},
	})
else
	insert("a", {
		"filename",
		icon = "",
		path = 1,
	})
	statusline.inactive.lualine_c = {
		-- Dummy component that centers the subsequent section.
		{
			function()
				return "%="
			end,
		},
		{
			"filename",
			icons_enabled = true,
			icon = "",
			path = 1,
		},
	}
end

insert("b", {
	"filetype",
	icons_enabled = true,
	colored = false,
	cond = function()
		return use_winbar or winwidth(0) > 73
	end,
})

insert("c", {
	function()
		return use_winbar and "%m%r%w" or ""
	end,
	padding = {},
})

insert("c", {
	function()
		return "%l:%c/%p%%"
	end,
	-- for literal table indexing: https://stackoverflow.com/questions/19331262
	icon = ({ full = "󰆋", outline = "󰆌" }).full,
	cond = function()
		return use_winbar or winwidth(0) > 80
	end,
})

insert("c", {
	"diagnostics",
	-- Having both nvim_diagnostic and nvim_lsp leads to the component
	-- reporting twice the number of errors.
	sources = { "nvim_diagnostic" },
	coloured = true,
	symbols = require("ps.vim_diagnostic").icons,
})

insert("x", {
	lsp_progress.progress,
	-- function()
	--   local clients = vim.lsp.get_active_clients({ bufnr = 0 })
	--   if #clients == 1 then
	--     return string.sub(clients[1].name, 1, 1)
	--   end
	--   local names = vim.tbl_map(function(client)
	--     return client.name
	--   end, clients)
	--   return table.concat(names, ", ")
	-- end,
	icon = ({ full = "", outline = "" }).outline,
	-- cond = function()
	-- 	return #vim.lsp.get_active_clients { bufnr = 0 } > 0
	-- 		and (use_winbar or winwidth(0) > 63)
	-- end,
})

insert("x", {
	"diff",
	colored = true,
	source = function()
		local gitsigns = vim.b.gitsigns_status_dict
		if gitsigns then
			return {
				added = gitsigns.added,
				modified = gitsigns.changed,
				removed = gitsigns.removed,
			}
		end
	end,
})

insert("x", {
	"b:gitsigns_head",
	icon = "",
})

insert("y", {
	"encoding",
	icons_enabled = false,
	cond = function()
		-- Bring more attention by only displaying when not utf-8
		return vim.opt.encoding:get() ~= "utf-8"
			and (use_winbar or vim.fn.winwidth(0) > 53)
	end,
})

insert("y", {
	"fileformat",
	icons_enabled = false,
	cond = function()
		-- Bring more attention by only displaying when not unix
		return vim.opt.fileformat:get() ~= "unix"
			and (use_winbar or vim.fn.winwidth(0) > 46)
	end,
})

insert("z", {
	function()
		return " "
	end,
	padding = {},
})

return {
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup {
				options = {
					-- I assume the theme will configure lualine_c and x sections sensibly.
					theme = "auto",
					component_separators = "",
					section_separators = "",
					globalstatus = use_winbar,
				},
				sections = statusline.active,
				inactive_sections = statusline.inactive,
				tabline_section = {
					lualine_a = {
						"filename",
						path = 2,
					},
				},
				winbar = winbar.active,
				inactive_winbar = winbar.inactive,
			}
			vim.api.nvim_create_autocmd("User", {
				group = vim.api.nvim_create_augroup(
					"lualine_lsp_progress",
					{ clear = true }
				),
				pattern = "LspProgressStatusUpdated",
				callback = require("lualine").refresh,
			})
		end,
	},
}
