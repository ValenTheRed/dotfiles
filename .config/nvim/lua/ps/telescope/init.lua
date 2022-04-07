-- Ref:
--- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/init.lua
if not pcall(require, "telescope") then
    return
end

local M = {}
local builtin = require('telescope.builtin')

function M.buffers()
    builtin.buffers({
        previewer = false,
        shorten_path = false,
    })
end

function M.find_files()
    builtin.find_files({
        previewer = false,
    })
end

function M.live_grep()
    builtin.live_grep()
end

function M.oldfiles()
    builtin.oldfiles({
        previewer = false,
    })
end

function M.colorscheme()
    builtin.colorscheme({
        enable_preview = true,
    })
end

-- TODO: telescope doesn't search amongst the register's value
-- M.registers = builtin.registers

function M.lsp_definitions()
    builtin.lsp_definitions()
end

function M.lsp_implementations()
    builtin.lsp_implementations()
end

function M.lsp_references()
    builtin.lsp_references()
end

function M.lsp_document_symbols()
    builtin.lsp_document_symbols({
        previewer = false,
    })
end

function M.lsp_workspace_symbols()
    builtin.lsp_workspace_symbols()
end

function M.lsp_type_definitions()
    builtin.lsp_type_definitions()
end

function M.lsp_code_actions()
    builtin.lsp_code_actions({
        previewer = false,
    })
end

return M
