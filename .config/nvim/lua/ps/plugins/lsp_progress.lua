local function client_format(client_name, spinner, series_messages)
	if #series_messages == 0 then
		return nil
	end
	return {
		name = client_name,
		body = spinner .. " " .. table.concat(series_messages, ", "),
	}
end

local function format(client_messages)
	--- @param name string
	--- @param msg string?
	--- @return string
	local function stringify(name, msg)
		return msg and string.format("%s %s", name, msg) or name
	end

	local lsp_clients = vim.lsp.get_active_clients {
		bufnr = 0,
	}
	if #lsp_clients <= 0 then
		return ""
	end

	local messages_map = {}
	for _, climsg in ipairs(client_messages) do
		messages_map[climsg.name] = climsg.body
	end

	-- table.sort(lsp_clients, function(a, b)
	--   return a.name < b.name
	-- end)
	local builder = {}
	for _, cli in ipairs(lsp_clients) do
		if
			type(cli) == "table"
			and type(cli.name) == "string"
			and string.len(cli.name) > 0
		then
			table.insert(builder, stringify(cli.name, messages_map[cli.name]))
		end
	end
	if #builder <= 0 then
		return ""
	end
	return table.concat(builder, ", ")
end

return {
	{
		"linrongbin16/lsp-progress.nvim",
		config = function()
			require("lsp-progress").setup {
				client_format = client_format,
				format = format,
			}
		end,
	},
}
