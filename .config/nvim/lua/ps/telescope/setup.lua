local actions = require('telescope.actions')
local action_layout = require('telescope.actions.layout')

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
