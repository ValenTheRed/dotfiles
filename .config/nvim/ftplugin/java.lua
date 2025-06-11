local home = vim.fn.expand("$HOME")

local java_executable = "java"
local jdtls_launcher_path =
	home .. "/opt/jdt-language-server-1.48.0-202506032041/plugins/org.eclipse.equinox.launcher_1.7.0.v20250519-0528.jar"
local jdtls_config_path = home .. "/opt/jdt-language-server-1.48.0-202506032041/config_linux"
-- TODO: the way project_name is extracted is a footgun. Make it
-- better.
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local jdtls_workspace = vim.fn.expand("$XDG_DATA_HOME") .. "/jdtls-workspace"
local workspace_dir = jdtls_workspace .. "/" .. project_name
local format_xml_path = jdtls_workspace .. "/" .. "eclipse-java-google-style.xml"
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
				enabled = true,
				settings = {
					url = format_xml_path,
					profile = "GoogleStyle",
				},
			},
			signatureHelp = { enabled = true },
		},
	},
}
require("jdtls").start_or_attach(config)
