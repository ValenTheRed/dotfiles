local nmap = function(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, {
		noremap = true,
		silent = true,
		desc = desc,
	})
end

local texthl = {
	[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
	[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
	[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
	[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
}
local text = {
	[vim.diagnostic.severity.ERROR] = " ",
	[vim.diagnostic.severity.WARN] = " ",
	[vim.diagnostic.severity.INFO] = " ",
	[vim.diagnostic.severity.HINT] = "󰌵 ",
}

vim.diagnostic.config {
	virtual_text = { prefix = "●", },
	signs = false,
	status = {
		format = function(counts)
			local items = {}
			for level, _ in ipairs(vim.diagnostic.severity) do
				local count = counts[level] or 0
				if count > 0 then
					table.insert(
						items,
						("%%#%s#%s%s"):format(texthl[level], text[level], count)
					)
				end
			end
			return table.concat(items, " ")
		end
	}
}

-- d- is the same as d1k. So useless and available to map.
nmap(
	"d-",
	function()
		vim.diagnostic.open_float { scope = "line", source = true }
	end,
	"open line diagnostics in a floating window"
)
nmap("dl", vim.diagnostic.setloclist, "vim.diagnostic.setloclist")
nmap(
	"[d",
	function()
		vim.diagnostic.jump({ count = -1, float = true })
	end,
	"jump to previous diagnostic in buffer"
)
nmap(
	"]d",
	function()
		vim.diagnostic.jump({ count = 1, float = true })
	end,
	"jump to next diagnostic in buffer"
)
