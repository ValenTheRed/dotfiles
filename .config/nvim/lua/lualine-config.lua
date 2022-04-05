local custom_material = require('lualine.themes.material')

custom_material.normal.c.bg = vim.g.material_colorscheme_map.selection.gui
custom_material.normal.c.fg = vim.g.material_colorscheme_map.fg.gui
custom_material.inactive.c.bg = vim.g.material_colorscheme_map.selection.gui
custom_material.inactive.c.fg = vim.g.material_colorscheme_map.fg.gui

require('lualine').setup({
    options = {
        theme = custom_material,
        icons_enabled = false,
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = {'branch'},
        lualine_b = {'b:gitsigns_status', 'diagnostics'},
        lualine_c = {
            {
                'filename',
                path = 1,
            },
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_c = {
            {
                'filename',
                path = 1,
            },
        },
        lualine_x = {'location'},
    },
    tabline_section = {
        lualine_a = {
            {
                'filename',
                path = 0,
            }
        }
    }
})
