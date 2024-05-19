local java_executable = "path"
local jdtls_launcher_path = "path"
local jdtls_config_path = "path"
-- TODO: the way project_name is extracted is a footgun. Make it
-- better.
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.expand("~") .. "/jdtls-workspace/" .. project_name
local format_xml_path = "path"
local config = {
	cmd = {
		-- 💀
		java_executable,
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		-- 💀
		"-jar",
		jdtls_launcher_path,
		-- 💀
		"-configuration",
		jdtls_config_path,
		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		workspace_dir,
	},
	settings = {
		java = {
			format = {
				settings = {
					url = format_xml_path,
				},
			},
		},
	},
}
require("jdtls").start_or_attach(config)
