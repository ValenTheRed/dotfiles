-- get_relative_path returns the relative path of `of` as measured from
-- `from`. `from` must be a absolute path. (Not enforced as of yet.)
---@param of string
---@param from string
---@return string
local get_relative_path = function(of, from)
	local rel_path = string.gsub(of, from, "")
	-- remove leading '/'
	rel_path = string.sub(rel_path, 2)
	return rel_path
end

-- get_test_dir returns the path of the test directory within `root`.
---@param root string
---@return string|nil
local get_test_dir = function(root)
	for _, dir in ipairs { "/__tests__", "/__test__", "/_test_", "/_tests_" } do
		local test_dir = root .. dir
		if vim.fn.isdirectory(test_dir) ~= 0 then
			return test_dir
		end
	end
end

-- Functionality –
-- 1. `:Jest` runs `yarn test` for the root dir containing jest.config.js
-- 2. `:Jest %` runs `yarn test` for the file (or directory if a directory buffer is open?)
-- 3. `:Jest %:h` runs `yarn test` for the directory
--
-- You can use `:Jest` with a bang to get coverage.
-- 1. `:Jest!` runs `yarn test --coverage` for the root dir containing jest.config.js.
-- 2. `:Jest! %` runs coverage for the file. The '%' file can be a source file
--    or a test file. We intelligently detect which and run the test file with
--    coverage collected only for that file.
-- 3. `:Jest! %:h` runs coverage for the directory. The '%:h' directory can be
--    a source or a test directory. We intelligently detect which and run the
--    tests for that directory with coverage collected only for that directory.
vim.api.nvim_create_user_command("Jest", function(opts)
	local files = vim.fs.find("jest.config.js", {
		upward = true,
		type = "file",
		stop = vim.loop.os_homedir(),
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	})
	if #files <= 0 then
		vim.notify(
			"Cannot find root marker jest.config.js",
			vim.log.levels.ERROR
		)
		return
	end

	local jest_root_dir = vim.fn.fnamemodify(files[1], ":h")
	local testee, jest_opts = "", ""
	if #opts.fargs > 0 then
		testee = vim.fs.normalize(
			vim.fn.fnamemodify(vim.fn.expand(table.remove(opts.fargs)), ":p")
		)
		jest_opts = table.concat(opts.fargs, " ")
	end
	local coverage_cmd = ""
	if opts.bang then
		coverage_cmd = "--coverage"
	end
	if vim.fn.filereadable(testee) ~= 0 then
		local filename = vim.fn.fnamemodify(testee, ":t")
		local extension = vim.fn.fnamemodify(filename, ":e")

		local src_file
		if string.find(filename, "test") == nil then
			-- User has provided src file, we need to find the test file.
			local fname_no_extention = vim.fn.fnamemodify(filename, ":r")
			local src_dir = vim.fn.fnamemodify(testee, ":h")
			---@type string
			local test_dir = get_test_dir(src_dir)
			local test_file = string.format(
				"%s/%s.test.%s",
				test_dir,
				fname_no_extention,
				extension
			)
			src_file = testee
			testee = test_file
		elseif opts.bang then
			-- Finding the src file only makes sense if we're also trying to
			-- find the coverage of the file.
			--
			-- User has provided the test file, we need to find the src file.
			local fname_no_extention = vim.fn.fnamemodify(filename, ":r:r")
			local src_dir = vim.fn.fnamemodify(testee, ":h:h")
			src_file = string.format(
				"%s/%s.%s",
				src_dir,
				fname_no_extention,
				extension
			)
		end
		if opts.bang then
			coverage_cmd = string.format(
				"--coverage --collectCoverageFrom=%s",
				get_relative_path(src_file, jest_root_dir)
			)
		end
	elseif vim.fn.isdirectory(testee) ~= 0 then
		local dirname = vim.fn.fnamemodify(testee, ":t")

		local src_dir
		if string.find(dirname, "test") == nil then
			-- User has provided src dir, we need to find the test dir.
			local test_dir = get_test_dir(testee)
			src_dir = testee
			testee = test_dir
		elseif opts.bang then
			-- Again, finding the src dir only makes sense if we're also trying
			-- to find the coverage of the dir.
			--
			-- User has provided the test dir, we need to find the src dir.
			src_dir = vim.fn.fnamemodify(testee, ":h")
		end
		if opts.bang then
			coverage_cmd = string.format(
				"--coverage --collectCoverageFrom='%s/*'",
				get_relative_path(src_dir, jest_root_dir)
			)
		end
	end

	vim.cmd.split(
		string.format(
			"term://cd '%s' && yarn test %s %s %s",
			jest_root_dir,
			jest_opts,
			coverage_cmd,
			testee
		)
	)
end, { bang = true, nargs = "*", complete = "file" })
