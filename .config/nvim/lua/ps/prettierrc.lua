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
	printWidth = {
		{ name = "max_line_length", type = "number" }
	},
	-- NOTE: typeof useTabs = boolean and typeof indent_style = "tab" | "space"
	useTabs = {
		from = "boolean",
		{ name = "indent_style", type = "string" }
	},
	-- typeof both is number
	tabWidth = {
		{ name = "indent_size", type = "number" },
		{ name = "tab_width",   type = "number" }
	},
	-- typeof endOfLine = "lf" | crlf" | "cr" | "auto" and typeof end_of_line = "lf" | crlf" | "cr"
	endOfLine = {
		{ name = "end_of_line", type = "string" }
	},
}

local default_opts = {
	max_line_length = 80,
	indent_style = "space",
	indent_size = 2,
	end_of_line = "lf",
}

local function strip_quotes(s)
	return string.gsub(s, [["]], "")
end

local function split_line(line)
	local at = line:find(":", 1, true)
	if not at then
		return
	end
	local key, value = line:sub(1, at - 1), line:sub(at + 1)
	return strip_quotes(trim(key, ",")), strip_quotes(trim(value, ","))
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
		if key == nil then
			goto continue
		end
		local opt_tbl = dictionary[key]
		if opt_tbl == nil then
			goto continue
		end
		for _, opt in ipairs(opt_tbl) do
			-- vim.notify(string.format("key: %s\nvalue: %s\nopt_tbl: %s\n\n", key, value, vim.inspect(opt_tbl)), vim.log.levels.INFO)
			if key and opt.name and not opts[opt.name] then
				local cvalue
				if opt_tbl.from == "boolean" then
					cvalue = value == "true"
				end
				if opt.type == "number" then
					cvalue = tonumber(value)
				end
				if key == "useTabs" then
					-- vim.notify(string.format("cvalue: %s", vim.inspect(cvalue)))
					opts[opt.name] = cvalue and "tab" or "space"
				else
					opts[opt.name] = cvalue
				end
			end
		end
		::continue::
	end
	f:close()
	-- vim.notify(string.format("parsed opts: %s", vim.inspect(opts)))
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
