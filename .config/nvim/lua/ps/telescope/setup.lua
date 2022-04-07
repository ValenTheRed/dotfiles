local actions = require('telescope.actions')

local defaults = {
    -- defaults doesn't support the key, defining it inside of a theme
    -- works.
    --results_title = false
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
        width = 0.95,
        height = 0.85,
        prompt_position = "top",
        preview_width = function(_, cols, _)
            if cols > 200 then
                return math.floor(cols * 0.4)
            else
                return math.floor(cols * 0.6)
            end
        end,
    },
    border = true,

    vimgrep_arguments = {
        "rg", "--vimgrep", "--trim"
    },
    mappings = {
        i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
        },
    },
}

require('telescope').setup({
    defaults = defaults,
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
