local eviline = {}
local c = require("psmdc.colors").dark

eviline.sections = {
  -- set empty table to remove dafaults
  lualine_a = {},
  lualine_b = {},
  lualine_y = {},
  lualine_z = {},
  -- These will be filled later
  lualine_c = {},
  lualine_x = {},
}

eviline.inactive_sections = {
  lualine_c = {
    {
      'filename',
      path = 1,
      color = { gui="bold" },
    },
    { 'progress' },
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(eviline.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(eviline.sections.lualine_x, component)
end

local function current_mode_colour()
  local mode_color = {
    ['n']    = c.purple, --    'NORMAL',
    ['niI']  = c.purple, --    'NORMAL',
    ['niR']  = c.purple, --    'NORMAL',
    ['niV']  = c.purple, --    'NORMAL',
    ['nt']   = c.purple, --    'NORMAL',
    ['no']   = c.purple, --    'O-PENDING',
    ['nov']  = c.purple, --    'O-PENDING',
    ['noV']  = c.purple, --    'O-PENDING',
    ['no'] = c.purple, --    'O-PENDING',

    ['v']    = c.paleyellow, --'VISUAL',
    ['vs']   = c.paleyellow, --'VISUAL',
    ['V']    = c.paleyellow, --'V-LINE',
    ['Vs']   = c.paleyellow, --'V-LINE',
    ['']   = c.paleyellow, --'V-BLOCK',
    ['s']  = c.paleyellow, --'V-BLOCK',
    ['s']    = c.yellow, --    'SELECT',
    ['S']    = c.yellow, --    'S-LINE',
    ['']   = c.yellow, --    'S-BLOCK',

    ['t']    = c.pink, --      'TERMINAL',
    ['i']    = c.pink, --      'INSERT',
    ['ic']   = c.pink, --      'INSERT',
    ['ix']   = c.pink, --      'INSERT',

    ['r']    = c.orange, --    'REPLACE',
    ['R']    = c.orange, --    'REPLACE',
    ['Rc']   = c.orange, --    'REPLACE',
    ['Rx']   = c.orange, --    'REPLACE',
    ['Rv']   = c.orange, --    'V-REPLACE',
    ['Rvc']  = c.orange, --    'V-REPLACE',
    ['Rvx']  = c.orange, --    'V-REPLACE',

    ['c']    = c.cyan, --      'COMMAND',
    ['cv']   = c.cyan, --      'EX',
    ['ce']   = c.cyan, --      'EX',

    ['rm']   = c.purple, --    'MORE',
    ['r?']   = c.purple, --    'CONFIRM',
    ['!']    = c.purple, --    'SHELL',
  }
  return mode_color[vim.fn.mode()]
end

ins_left {
  function() return "█" end,
  color = function()
    return { fg=current_mode_colour() }
  end,
  padding = {},
}

ins_left {
  'filename',
  icons_enabled = true,
  icon = "",
  path = 1,
  color = { bg=c.selection2 }
}

ins_left {
  'filetype',
  -- hide when width less than 70
  cond = function() return vim.fn.winwidth(0) > 80 end,
}

-- default component has too much space around it
ins_left {
  function ()
    return " %l:%c"
  end
}

ins_left {
  'diagnostics',
  -- Having both nvim_diagnostic and nvim_lsp leads to the component
  -- reporting twice the number of errors.
  sources = { 'nvim_diagnostic', },
  -- Redundant defining of symbols; already in lsp.lua.
  -- TODO(ps): structure lua folder to get symbols from lsp.lua
  symbols = { error = " ", warn = " ", info = " ", hint = " " },
}

-- from lualine's wiki
ins_right {
  'diff',
  source = function()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed
      }
    end
  end,
}

ins_right {
  'branch',
  icons_enabled = true,
  icon = "",
}

ins_right {
  'encoding',
  color = { bg=c.selection2 },
  cond = function()
    -- Bring more attention by only displaying when not utf-8
    return vim.opt.encoding:get() ~= "utf-8" and vim.fn.winwidth(0) > 75
  end,
}

ins_right {
  'fileformat',
  color = { bg=c.selection2 },
  cond = function()
    -- Bring more attention by only displaying when not unix
    return vim.opt.fileformat:get() ~= "unix" and vim.fn.winwidth(0) > 70
  end,
}

ins_right {
  function() return "█" end,
  color = function()
    return { fg=current_mode_colour() }
  end,
  padding = {},
}

return eviline
