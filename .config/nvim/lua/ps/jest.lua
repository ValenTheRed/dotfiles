--- The command to run tests is this
---
--- ```bash
--- yarn test <opts> <test file/directory>
--- ```
---
--- If you run only `yarn test`, it first finds the jest config directory by
--- going recursively upwards. When it finds it, it runs the test for the all
--- of the tests it finds in that directory.
---
--- If you want to find the coverage of a file, you need to use this option:
--- `collectCoverageFrom=<path to src file/dir of the test file/dir>`. The path
--- src file needs to be relative to the root directory where the jest config
--- lives.
---
--- As it is now, running `yarn test` is pain for running tests for a single
--- file or directory, especially if you want the coverage for the files.
--- Hence, the `:Jest` command.
---
--- The command needs to --
--- 1. handle running `yarn test` from both, test and src file/directory.
--- 2. add correct `collectCoverageFrom` when given test or src file/directory.

local TEST_DIRS = { "/__tests__", "/__test__", "/_test_", "/_tests_" }

local is_file = function(path)
	return vim.fn.filereadable(path) ~= 0
end

local is_directory = function(path)
	return vim.fn.isdirectory(path) ~= 0
end

local contains_test = function(string)
	return string.find(string, "test") ~= nil
end

-- get_test_dir returns the path of the test directory within `root`.
---@param root string
---@return string|nil
local get_test_dir_path = function(root)
	for _, dir in ipairs(TEST_DIRS) do
		local test_dir = root .. dir
		if is_directory(test_dir) then
			return test_dir
		end
	end
end

-- get_relative_path returns the relative path of `of` as measured from
-- `from`. `from` must be a absolute path. (Not enforced as of yet.)
---@param of string
---@param from string
---@return string
local get_relative_path = function(of, from)
	local escaped_from = string.gsub(from, "%-", "%%-")
	local rel_path = string.gsub(of, escaped_from, "")
	-- remove leading '/'
	rel_path = string.sub(rel_path, 2)
	return rel_path
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
		stop = vim.uv.os_homedir(),
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	})
	if #files <= 0 then
		vim.notify(
			"Cannot find root marker jest.config.js",
			vim.log.levels.ERROR
		)
		return
	end

	-- there's always going to be only one config file in directory
	local config_path   = files[1]
	local root_path     = vim.fn.fnamemodify(config_path, ":h")

	local arg_test_path = ""
	local cmd_opts      = ""
	local coverage_cmd  = {}
	if #opts.fargs > 0 then
		arg_test_path = vim.fs.normalize(
			vim.fn.fnamemodify(vim.fn.expand(table.remove(opts.fargs)), ":p")
		)
		cmd_opts = table.concat(opts.fargs, " ")
	end

	if opts.bang then
		table.insert(coverage_cmd, "--coverage")
	end

	local test_path = ""
	local arg_test_name = vim.fn.fnamemodify(arg_test_path, ":t")

	if opts.bang and is_directory(root_path .. "/__tests__") and is_directory(arg_test_path) then
		local rel_test_dir_path = get_relative_path(
			arg_test_path, root_path .. "/__tests__"
		)
		local src_dir_path = string.format(
			"%s/src/%s",
			root_path,
			rel_test_dir_path
		)
		local coverage_path = src_dir_path
		test_path = arg_test_path
		-- vim.notify(string.format("%s\n%s\n%s\n%s", arg_test_path, rel_test_dir_path, coverage_path, root_path), vim.log.levels.INFO)
		table.insert(
			coverage_cmd,
			string.format(
				"--collectCoverageFrom='%s/*'",
				get_relative_path(coverage_path, root_path)
			)
		)
	elseif not opts.bang and contains_test(arg_test_name) then
		test_path = arg_test_path
	elseif opts.bang and contains_test(arg_test_name) then
		local coverage_path
		if is_file(arg_test_path) then
			if is_directory(root_path .. "/__tests__") then
				local test_dir_path = vim.fn.fnamemodify(arg_test_path, ":h")
				local rel_test_dir_path = get_relative_path(
					test_dir_path, root_path .. "/__tests__"
				)
				local filename = vim.fn.fnamemodify(arg_test_name, ":r:r")
				local extension = vim.fn.fnamemodify(arg_test_name, ":e")
				local src_file_path = string.format(
					"%s/src/%s/%s.%s",
					root_path,
					rel_test_dir_path,
					filename,
					extension
				)
				coverage_path = src_file_path
				test_path = arg_test_path
			else
				local src_dir_path = vim.fn.fnamemodify(arg_test_path, ":h:h")
				local filename = vim.fn.fnamemodify(arg_test_name, ":r:r")
				local extension = vim.fn.fnamemodify(arg_test_name, ":e")
				local src_file_path = string.format(
					"%s/%s.%s", src_dir_path, filename, extension
				)
				test_path = arg_test_path
				coverage_path = src_file_path
			end
		elseif is_directory(arg_test_path) then
			test_path = arg_test_path
			local src_dir_path = vim.fn.fnamemodify(arg_test_path, ":h")
			coverage_path = src_dir_path
		end
		table.insert(
			coverage_cmd,
			string.format(
				[[--collectCoverageFrom="%s"]],
				get_relative_path(coverage_path, root_path)
			)
		)
	elseif arg_test_name ~= "" and not contains_test(arg_test_name) then
		local src_dir_path
		if is_file(arg_test_path) then
			src_dir_path = vim.fn.fnamemodify(arg_test_path, ":h")
		elseif is_directory(arg_test_path) then
			src_dir_path = arg_test_path
		end
		local test_dir_path = get_test_dir_path(src_dir_path)
		if test_dir_path == nil then
			vim.notify(
				string.format(
					"Cannot find any of %s in %s",
					vim.inspect(TEST_DIRS),
					src_dir_path
				),
				vim.log.levels.ERROR
			)
			return
		end
		if is_file(arg_test_path) then
			local filename = vim.fn.fnamemodify(arg_test_name, ":r")
			local extension = vim.fn.fnamemodify(arg_test_name, ":e")
			test_path = string.format(
				"%s/%s.test.%s",
				test_dir_path,
				filename,
				extension
			)
		elseif is_directory(arg_test_path) then
			test_path = test_dir_path
		end
		if opts.bang then
			table.insert(
				coverage_cmd,
				string.format(
					"--collectCoverageFrom=%s",
					get_relative_path(arg_test_path, root_path)
				)
			)
		end
	end

	vim.cmd.split(
		string.format(
		-- NOTE: we'll *always* update snapshots
			"term://cd '%s' && yarn test -u %s %s %s",
			root_path,
			cmd_opts,
			table.concat(coverage_cmd, " "),
			test_path
		)
	)
end, { bang = true, nargs = "*", complete = "file" })
