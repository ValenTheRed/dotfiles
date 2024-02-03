local nmap = function(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, {
		noremap = true,
		silent = true,
		desc = desc,
		buffer = 0,
	})
end

local toggle_document_highlight = (function()
	local id = vim.api.nvim_create_augroup("lsp_document_highlight", {
		clear = true,
	})
	return function()
		-- [Reference](https://vi.stackexchange.com/questions/4120) for
		-- toggling autocmds.
		if
			vim.fn.exists("#lsp_document_highlight#CursorHold#<buffer>") ~= 0
		then
			vim.notify("nohldocument")
			-- Clearing autocmds doesn't automatically clear the highlights.
			vim.lsp.buf.clear_references()
			-- Only clear the autocmds defined for the current buffer,
			-- otherwise highlights in other buffers will disappear.
			vim.api.nvim_clear_autocmds { buffer = 0, group = id }
		else
			vim.notify("hldocument")
			vim.api.nvim_create_autocmd("CursorHold", {
				group = id,
				buffer = 0,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd("CursorMoved", {
				group = id,
				buffer = 0,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end
end)()

local efm_prettierd = {
	formatCanRange = true,
	formatCommand = "prettierd '${INPUT}' ${--range-start=charStart} ${--range-end=charEnd} ${--tab-width=tabSize} ${--use-tabs=!insertSpaces}",
	formatStdin = true,
	rootMarkers = {
		".prettierrc",
		".prettierrc.json",
		".prettierrc.js",
		".prettierrc.yml",
		".prettierrc.yaml",
		".prettierrc.json5",
		".prettierrc.mjs",
		".prettierrc.cjs",
		".prettierrc.toml",
	},
}

local efm_eslintd = {
	lintSource = "efm/eslint_d",
	lintCommand = 'eslint_d --no-color --format unix --stdin-filename "${INPUT}" --stdin',
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
	lintIgnoreExitCode = true,
	rootMarkers = {
		".eslintrc",
		".eslintrc.cjs",
		".eslintrc.js",
		".eslintrc.json",
		".eslintrc.yaml",
		".eslintrc.yml",
	},
}

local efm_languages = {
	javascriptreact = { efm_prettierd, efm_eslintd },
	javascript = { efm_prettierd, efm_eslintd },
	typescriptreact = { efm_prettierd, efm_eslintd },
	typescript = { efm_prettierd, efm_eslintd },
	json = { efm_prettierd },
	lua = {
		{
			formatCanRange = true,
			formatCommand = "stylua ${--range-start:charStart} ${--range-end:charEnd} -",
			formatStdin = true,
			rootMarkers = { "stylua.toml", ".stylua.toml" },
		},
	},
}

local config = function()
	local telescope_builtin = require("telescope.builtin")
	local telescope_lsp_opts = { show_line = false }

	-- For nvim-cmp
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
		local cond_nmap = function(capability, ...)
			if client.server_capabilities[capability] then
				nmap(...)
			end
		end

		-- See `:help vim.lsp.*` for documentation on any of the below functions
		-- [server capabilities](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities)

		cond_nmap(
			"declarationProvider",
			"gD",
			vim.lsp.buf.declaration,
			"lsp.declaration"
		)

		cond_nmap(
			"hoverProvider",
			"K",
			vim.lsp.buf.hover,
			"floating lsp symbol info"
		)

		cond_nmap("definitionProvider", "gd", function()
			telescope_builtin.lsp_definitions(telescope_lsp_opts)
		end, "Telescope list/goto definitions")

		-- Default mapping of gi is occasionally useful. Default gR seems pretty useless.
		cond_nmap("implementationProvider", "gR", function()
			telescope_builtin.lsp_implementations(telescope_lsp_opts)
		end, "Telescope list/goto implementations")

		cond_nmap(
			"signatureHelpProvider",
			"gs",
			vim.lsp.buf.signature_help,
			"floating lsp function signature help"
		)

		cond_nmap("referencesProvider", "gr", function()
			telescope_builtin.lsp_references(telescope_lsp_opts)
		end, "Telescope lists references")

		cond_nmap("typeDefinitionProvider", "<space>D", function()
			telescope_builtin.lsp_type_definitions(telescope_lsp_opts)
		end, "Telescope list/goto type definitions")

		cond_nmap("documentSymbolProvider", "<space>dr", function()
			telescope_builtin.lsp_document_symbols {
				previewer = true,
			}
		end, "Telescope list doc symbols")

		cond_nmap(
			"workspaceSymbolProvider",
			"<space>wr",
			telescope_builtin.lsp_workspace_symbols,
			"Telescope list lsp workspace symbols"
		)

		cond_nmap("workspace", "<space>wa", vim.lsp.buf.add_workspace_folder)
		cond_nmap("workspace", "<space>wr", vim.lsp.buf.remove_workspace_folder)
		cond_nmap("workspace", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "print workspace folders in :messages section")

		cond_nmap(
			"renameProvider",
			"<space>rn",
			vim.lsp.buf.rename,
			"lsp rename identifier under cursor"
		)

		cond_nmap("codeActionProvider", "<space>ca", function()
			telescope_builtin.lsp_code_actions {
				previewer = false,
			}
		end, "Telescope list code actions")

		if client.name == "tsserver" then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		cond_nmap(
			"documentFormattingProvider",
			"<space>f",
			vim.lsp.buf.format,
			"vim.lsp.buf.format"
		)

		cond_nmap(
			"documentHighlightProvider",
			"<space>dh",
			toggle_document_highlight,
			"toggle ide-like symbol under cursor highlight"
		)
	end

	-- Enable the following language servers
	local lsp = require("lspconfig")
	lsp.pyright.setup { on_attach = on_attach, capabilities = capabilities }
	lsp.gopls.setup { on_attach = on_attach, capabilities = capabilities }
	lsp.tsserver.setup {
		root_dir = function(filename)
			if
				string.find(filename, "substitute_this_with_a_directory") ~= nil
			then
				return lsp.util.find_git_ancestor(filename)
			end
			-- This is the default config set by lspconfig.
			-- Check `:h lspconfig-server-configurations` & `/# tsserver`
			return lsp.util.root_pattern(
				"package.json",
				"tsconfig.json",
				"jsconfig.json",
				".git"
			)(filename)
		end,
		on_attach = on_attach,
		capabilities = capabilities,
	}
	lsp.efm.setup {
		on_attach = on_attach,
		capabilities = capabilities,
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
		},
		filetypes = vim.tbl_keys(efm_languages),
		settings = {
			rootMarkers = { ".git/" },
			languages = efm_languages,
		},
	}
end

return { {
	"neovim/nvim-lspconfig",
	config = config,
} }
