-- Ref:
--- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/mappings.lua
--- https://github.com/nanotee/nvim-lua-guide

-- This ain't local. Why?
TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(key, fn, options, buffer)
    -- Normalised, as this will be used as a key in TelescopeMapArgs
    local map_key = vim.api.nvim_replace_termcodes(key .. fn, true, true, true)
    TelescopeMapArgs[map_key] = options or {}

    local mode = "n"
    local rhs = string.format("<cmd>lua require('ps.telescope')['%s'](TelescopeMapArgs['%s'])<CR>", fn, map_key)
    local map_opts = { noremap = true, silent = true }

    if not buffer then
        vim.api.nvim_set_keymap(mode, key, rhs, map_opts)
    else
        vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_opts)
    end
end

-- ff: convenient position
map_tele("<leader>ff", "buffers")
map_tele("<leader>fd", "find_files")
-- fg: file grep
map_tele("<leader>fg", "live_grep")
-- fm: file most recently used
map_tele("<leader>fm", "oldfiles")

return map_tele
