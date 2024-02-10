return {
	s(
		{
			trig = "fne",
			snippetType = "autosnippet",
			dscr = "create function",
		},
		fmta(
			[[
			function<>(<>)
				<>
			end
			]],
			{ i(1), i(2), i(3) }
		)
	),
	s(
		{
			trig = "ife",
			snippetType = "autosnippet",
			dscr = "if construct",
		},
		fmta(
			[[
			if <> then
				<>
			end
			]],
			{ i(1), i(2) }
		)
	),
	s(
		{
			trig = "fore",
			snippetType = "autosnippet",
			dscr = "for construct",
		},
		fmta(
			[[
			for <> do
				<>
			end
			]],
			{ i(1), i(2) }
		)
	),
}
