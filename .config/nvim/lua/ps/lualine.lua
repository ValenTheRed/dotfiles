-- Definig the statusline.
local statusline = {}

-- set empty table to remove dafaults
statusline.sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {},
  lualine_x = {},
  lualine_y = {},
  lualine_z = {},
}

-- set empty table to remove dafaults
statusline.inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {},
  lualine_x = {},
  lualine_y = {},
  lualine_z = {
    {
      'filename',
      icons_enabled = true,
      icon = "",
      path = 1,
    },
  },
}

-- Inserts component at lualine section {a, b, c, x, y, z}
local function insert(section, component)
  table.insert(statusline.sections[string.format("lualine_%s", section)], component)
end

insert("a", {
  function() return " " end,
  padding = {},
})

insert("b", {
  'filename',
  icon = "",
  path = 1,
})

insert("c", {
  'filetype',
  icons_enabled = false,
  -- hide when width less than 70
  cond = function() return vim.fn.winwidth(0) > 80 end,
})

-- default component has too much space around it
insert("c", {
  function ()
    return "%l:%c"
  end,
  icon = "",
})

insert("c", {
  'diagnostics',
  -- Having both nvim_diagnostic and nvim_lsp leads to the component
  -- reporting twice the number of errors.
  sources = { 'nvim_diagnostic', },
  coloured = true,
  symbols = require("ps.vim_diagnostic").icons,
})

insert("x", {
  'diff',
  colored = true,
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
})

insert("x", {
  'branch',
  icon = "",
})

insert("y", {
  'encoding',
  icons_enabled = false,
  cond = function()
    -- Bring more attention by only displaying when not utf-8
    return vim.opt.encoding:get() ~= "utf-8" and vim.fn.winwidth(0) > 75
  end,
})

insert("y", {
  'fileformat',
  icons_enabled = false,
  cond = function()
    -- Bring more attention by only displaying when not unix
    return vim.opt.fileformat:get() ~= "unix" and vim.fn.winwidth(0) > 70
  end,
})

insert("z", {
  function() return " " end,
  padding = {},
})

require("lualine").setup {
  options = {
    -- I assume the theme will configure lualine_c and x sections sensibly.
    theme = "auto",
    component_separators = "",
    section_separators = "",
  },
  sections = statusline.sections,
  inactive_sections = statusline.inactive_sections,
  tabline_section = {
    lualine_a = {
      'filename',
      path = 2,
    }
  }
}
