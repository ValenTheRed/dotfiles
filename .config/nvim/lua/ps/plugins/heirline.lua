local ViMode = {
	-- init runs on evaluation of the component.
	init = function(self)
		self.mode = vim.fn.mode(1) -- :h mode()
	end,
	-- Now we define some dictionaries to map the output of mode() to the
	-- corresponding string and color. We can put these into `static` to compute
	-- them at initialisation time.
	static = {
		mode_colors = {
			n = "red",
			i = "green",
			v = "cyan",
			V = "cyan",
			["\22"] = "cyan",
			c = "orange",
			s = "purple",
			S = "purple",
			["\19"] = "purple",
			R = "orange",
			r = "orange",
			["!"] = "red",
			t = "red",
		},
	},
	-- provider returns the string that will be displayed.
	provider = function(self)
		return " " -- 
	end,
	hl = function(self)
		local mode = self.mode:sub(1, 1) -- get only the first mode character
		return { bg = self.mode_colors[mode] }
	end,
	-- Re-evaluate the component only on ModeChanged event!
	-- Also allows the statusline to be re-evaluated when entering operator-pending mode
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function()
			vim.cmd.redrawstatus()
		end),
	},
}

local BufTypeIcon = {
	init = function(self)
		local filetype = vim.bo.filetype
		if filetype == "netrw" then
			self.icon = self.netrw
		elseif filetype == "oil" then
			self.icon = self.oil
		elseif filetype == "help" then
			self.icon = self.help
		elseif filetype == "checkhealth" then
			self.icon = self.checkhealth
		elseif vim.bo.buftype == "terminal" then
			self.icon = self.terminal
		else
			self.icon = self.file
		end
	end,
	static = {
		file = "", -- 
		terminal = "", -- 
		oil = " ", -- 
		netrw = "󰡰", -- 󰒍 󰲁
		help = "󰠩", -- 󰝄 
		checkhealth = "", --  ♥ 󱙤 󱙣
	},
	provider = function(self)
		return self.icon .. " "
	end,
}

local FilePath = {
	provider = function(self)
		-- get relative filename
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
		if filename == "" then
			return "[No Name]"
		end
		if
			not require("heirline.conditions").width_percent_below(
				#filename,
				0.25
			)
		then
			filename = vim.fn.pathshorten(filename)
		end
		return filename
	end,
}

local FileStatusFlags = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = " [+]",
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = " ", -- 
	},
}

local FileType = {
	init = function(self)
		local filename = vim.api.nvim_buf_get_name(0)
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon = require("nvim-web-devicons").get_icon(filename, extension)
		self.icon = self.icon ~= "" and self.icon or ""
	end,
	provider = function(self)
		return self.icon .. " " .. vim.bo.filetype
	end,
}

local FileEncoding = {
	provider = vim.bo.fileencoding,
}

local FileFormat = {
	provider = vim.bo.fileformat,
}

local Ruler = {
	provider = "󰆋 %l:%c/%P", --     󰐃 󰆌
}

local LSPMessages = {
	provider = function()
		return require("lsp-progress").progress()
	end,
	update = {
		"User",
		pattern = "LspProgressStatusUpdated",
		callback = vim.schedule_wrap(function()
			vim.cmd.redrawstatus()
		end),
	},
}

local Diagnostics = {
	init = function(self)
		self.errors =
			#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings =
			#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.hints =
			#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		self.info =
			#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
		self.add_space = false
	end,
	static = {
		icons = {
			error = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
			warn = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
			info = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
			hint = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
		},
		space = function(add_space)
			return add_space and " " or ""
		end,
	},
	update = { "DiagnosticChanged", "BufEnter" },
	{
		condition = function(self)
			self.cond = self.errors > 0
			return self.cond
		end,
		init = function(self)
			self.add_space = self.add_space or self.cond
		end,
		provider = function(self)
			return self.icons.error .. " " .. self.errors
		end,
	},
	{
		condition = function(self)
			self.cond = self.warnings > 0
			return self.cond
		end,
		init = function(self)
			self.add_space = self.add_space or self.cond
		end,
		provider = function(self)
			return self.space(self.add_space)
				.. self.icons.warn
				.. " "
				.. self.warnings
		end,
	},
	{
		condition = function(self)
			self.cond = self.info > 0
			return self.cond
		end,
		init = function(self)
			self.add_space = self.add_space or self.cond
		end,
		provider = function(self)
			return self.space(self.add_space)
				.. self.icons.info
				.. " "
				.. self.info
		end,
	},
	{
		condition = function(self)
			self.cond = self.hints > 0
			return self.cond
		end,
		init = function(self)
			self.add_space = self.add_space or self.cond
		end,
		provider = function(self)
			return self.space(self.add_space)
				.. self.icons.hint
				.. " "
				.. self.hints
		end,
	},
}

local GitBranch = {
	provider = function()
		return "" .. " " .. vim.b.gitsigns_status_dict.head -- 
	end,
}

local GitChanges = {
	init = function(self)
		self.status = vim.b.gitsigns_status_dict
		self.add_space = false
	end,
	static = {
		space = function(add_space)
			return add_space and " " or ""
		end,
		get_condition = function(self, key)
			self.cond = self.status[key] ~= nil and self.status[key] ~= 0
			return self.cond
		end,
	},
	{
		condition = function(self)
			return self.get_condition(self, "removed")
		end,
		init = function(self)
			self.add_space = self.add_space or self.cond
		end,
		provider = function(self)
			return "-" .. self.status.removed
		end,
	},
	{
		condition = function(self)
			return self.get_condition(self, "added")
		end,
		init = function(self)
			self.add_space = self.add_space or self.cond
		end,
		provider = function(self)
			return self.space(self.add_space) .. "+" .. self.status.added
		end,
	},
	{
		condition = function(self)
			return self.get_condition(self, "changed")
		end,
		init = function(self)
			self.add_space = self.add_space or self.cond
		end,
		provider = function(self)
			return self.space(self.add_space) .. "~" .. self.status.changed
		end,
	},
}

local TabPage = {
	provider = function(self)
		return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
	end,
	hl = function(self)
		if not self.is_active then
			return "TabLine"
		else
			return "TabLineSel"
		end
	end,
}

local TabPageClose = {
	provider = "%999X  %X", --   󱎘
	hl = "TabLine",
}

local Space = {
	provider = " ",
}

local Align = {
	provider = "%=",
}

local config = function()
	local conds = require("heirline.conditions")
	local utils = require("heirline.utils")
	local withPadding = function(component, cond)
		return {
			condition = cond,
			Space,
			component,
			Space,
		}
	end

	local FileInfo = withPadding { BufTypeIcon, FilePath, FileStatusFlags }
	local FileType = withPadding(FileType, function()
		return vim.bo.filetype ~= ""
	end)
	local FileEncoding = withPadding(FileEncoding, function()
		local enc = vim.bo.fileencoding
		-- No need to show empty encoding as that means neovim writes in utf-8
		return enc ~= "" and enc ~= "utf-8"
	end)
	local FileFormat = withPadding(FileFormat, function()
		return vim.bo.fileformat ~= "unix"
	end)
	local Ruler = withPadding(Ruler)
	local LSPMessages = withPadding(LSPMessages, function()
		return #vim.lsp.get_active_clients { bufnr = 0 } > 0
	end)
	-- local Diagnostics = withPadding(Diagnostics, conds.has_diagnostics)
	local GitBranch = withPadding(GitBranch, conds.is_git_repo)
	local GitChanges = withPadding(GitChanges, conds.is_git_repo)
	local TabPages = {
		condition = function()
			return #vim.api.nvim_list_tabpages() >= 2
		end,
		{ provider = "%=" },
		utils.make_tablist(TabPage),
		TabPageClose,
	}

	return {
		winbar = { FileInfo },
		statusline = {
			FileType,
			Ruler,
			FileEncoding,
			FileFormat,
			Diagnostics,
			Align,
			GitChanges,
			LSPMessages,
			GitBranch,
		},
	}
end

return {
	"rebelot/heirline.nvim",
	config = function()
		require("heirline").setup(config())
	end,
}
