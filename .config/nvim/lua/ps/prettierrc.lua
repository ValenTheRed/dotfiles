-- For $WORK.
--- This plugin parses ".prettierrc.js" and sets their corresponding
--- editorconfig options on a per buffer basis.
local editorconfig = require("editorconfig")

local function warn(...)
	vim.notify(string.format(...), vim.log.levels.WARN)
end

local function trim(s, chars)
	local chars = "[%s" .. (chars or "") .. "]"
	return s:gsub(chars, "")
end

-- prettierrc -> editorconfig options
local dictionary = {
	-- typeof both is number
	printWidth = "max_line_length",
	-- NOTE: typeof useTabs = boolean and typeof indent_style = "tab" | "space"
	useTabs = "indent_style",
	-- typeof both is number
	tabWidth = "indent_size",
	-- typeof endOfLine = "lf" | crlf" | "cr" | "auto" and typeof end_of_line = "lf" | crlf" | "cr"
	endOfLine = "end_of_line",
}

local default_opts = {
	max_line_length = 80,
	indent_style = "space",
	indent_size = 2,
	end_of_line = "lf",
}

local function split_line(line)
	local at = line:find(":", 1, true)
	if not at then
		return
	end
	local key, value = line:sub(1, at - 1), line:sub(at + 1)
	return trim(key, ","), trim(value, ",")
end

-- parse parses prettierrc.js file and returns a table of the
-- prettier options that map onto editorconfig options.
-- NOTE: the options must be on a single line.
local function parse(path)
	local opts = {}
	local f = io.open(path)
	if not f then
		return opts
	end
	for line in f:lines() do
		-- local key, value = line:match([[^%s*(%a+)%s*:%s*['"]?(.-)['"]?,?$]])
		local key, value = split_line(line)
		local opt = dictionary[key]
		if key and opt and not opts[opt] then
			if key == "useTabs" then
				opts[opt] = value and "tab" or "space"
			else
				opts[opt] = value
			end
		end
	end
	f:close()
	return vim.tbl_extend("keep", opts, default_opts)
end

local function config(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local path = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
	if
		vim.bo[bufnr].buftype ~= ""
		or not vim.bo[bufnr].modifiable
		or path == ""
	then
		return
	end

	--- @type table<string,string>
	local opts = {}
	for _, rc in
	ipairs(vim.fs.find({ ".prettierrc.js", ".prettierrc" }, {
		path = path,
		upward = true,
		stop = vim.fn.expand("~"),
		type = "file",
	}))
	do
		opts = parse(rc)
	end

	--- @type table<string,string>
	local applied = {}
	for opt, val in pairs(opts) do
		local func = editorconfig.properties[opt]
		if func then
			local ok, err = pcall(func, bufnr, val, opts)
			if ok then
				applied[opt] = val
			else
				warn(
					"prettierrc->editorconfig: invalid value for option %s: %s. %s",
					opt,
					val,
					err
				)
			end
		end
	end

	vim.b[bufnr].editorconfig = applied
end

local group = vim.api.nvim_create_augroup("prettierrc_to_editorconfig", {})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufFilePost" }, {
	group = group,
	pattern = { "*.js", "*.ts", "*.tsx", "*.jsx", "*.json" },
	callback = function(args)
		local enable = vim.F.if_nil(
			vim.b.editorconfig,
			vim.F.if_nil(vim.g.editorconfig, true)
		)
		if not enable then
			return
		end
		config(args.buf)
	end,
})
