local actions = require('telescope.actions')
local action_layout = require('telescope.actions.layout')

local minimalist_square_box = require('telescope.themes').get_dropdown({
    borderchars = {
        { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
        prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
        results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
        preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
    },
    width = 0.8,
    previewer = false,
})

require('telescope').setup({
    defaults = {
        vimgrep_arguments = {
            "rg", "--vimgrep", "--trim"
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
        preview = false,
    },
    pickers = {
        buffers = {
            mappings = {
                i = {
                    ["<DEL>"] = actions.delete_buffer,
                },
                n = {
                    ["dd"] = actions.delete_buffer,
                }
            },
        },
    },
})

require('telescope').load_extension('fzf')

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd> Telescope buffers<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>fd', "<cmd> Telescope find_files<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>fr', "<cmd> Telescope live_grep<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>fm', "<cmd> Telescope oldfiles<CR>", opts)
-- Implement the following keymaps in lspconfig
-- vim.api.nvim_set_keymap('n', 'gd', "<cmd> Telescope lsp_definitions<CR>", opts)
-- vim.api.nvim_set_keymap('n', 'gi', "<cmd> Telescope lsp_implementations<CR>", opts)
-- vim.api.nvim_set_keymap('n', 'gr', "<cmd> Telescope lsp_references<CR>", opts)
-- vim.api.nvim_set_keymap('n', 'gdr', "<cmd> Telescope lsp_document_symbols<CR>", opts)
-- vim.api.nvim_set_keymap('n', 'gwr', "<cmd> Telescope lsp_workspace_symbols<CR>", opts)
-- vim.api.nvim_set_keymap('n', '<space>ca', "<cmd> Telescope lsp_code_actions<CR>", opts)
