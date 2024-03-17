-- NOTE: only supports ASCII identifiers
local split = function(line, sep)
	local elems = {}
	for item in string.gmatch(line, "[^" .. sep .. "]+") do
		local trimmed = string.gsub(item, "%s+", "")
		-- NOTE: don't inline `trimmed`. When I call it inside of `insert`, the
		-- snippets stop working. Don't know why.
		table.insert(elems, trimmed)
	end
	return elems
end

return {
	s(
		{
			trig = "fne",
			snippetType = "autosnippet",
			dscr = "create function",
		},
		fmt(
			[[
			(%?): %? => {
				%?
			}
			]],
			{ i(1), i(2), i(3) },
			{ delimiters = "%?" }
		)
	),
	s({
		trig = "usecon",
		dscr = "print and debug reactive values of react",
	}, {
		t {
			"useEffect(() => {",
			"\tconsole.info('pranjal --', ",
		},
		f(function(args)
			local idents = split(args[1][1], ",")
			local transformed = vim.tbl_map(function(ident)
				return string.format([['\n%s:', %s]], ident, ident)
			end, idents)
			return table.concat(transformed, ", ")
		end, { 1 }),
		t {
			")",
			"}, [",
		},
		i(1),
		t("])"),
	}),
}
