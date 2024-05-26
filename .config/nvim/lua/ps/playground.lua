vim.api.nvim_create_user_command("Playground", function(opts)
	local extension = opts.args
	local fname = string.format("main.%s", extension)

	local tmpfile = vim.fn.tempname()
	local tmpdir = vim.fn.fnamemodify(tmpfile, ":h")
	-- Need to add the buffer because for some filetypes, the extension alone
	-- is not enough to disambiguate the filetype.
	--
	-- Eg: 'ts' extension matches a xml and typescript file. See:
	-- `$VIMRUNTIME/lua/vim/filetype.lua`.
	--
	-- Also, the providing `contents = {''}` still returns `nil` even though
	-- logically it should return 'typescript'.
	local bufnr = vim.fn.bufadd(tmpdir .. "/" .. fname)

	if vim.filetype.match { buf = bufnr, filename = fname } == nil then
		vim.notify(
			string.format(
				"No filetype corresponding to the extension '%s' found",
				extension
			),
			vim.log.levels.ERROR
		)
		-- According to `:h bufadd`, it doesn't load the buffer; consequently,
		-- `unload = true` throws an error. So, I'm not sure whether I should
		-- delete the buffer, but I'm doing it anyways since there seems to be
		-- no harm.
		vim.api.nvim_buf_delete(bufnr, { force = true })
		return
	end

	vim.cmd.lcd(tmpdir)
	if opts.mods == "vertical" then
		vim.cmd.vsplit(fname)
	elseif opts.mods == "tab" then
		vim.cmd.tab(fname)
	elseif opts.mods == "horizontal" then
		vim.cmd.split(fname)
	else
		vim.cmd.edit(fname)
	end
end, { nargs = 1 })
