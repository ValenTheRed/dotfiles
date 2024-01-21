local set = vim.opt
local lsp_progress = require('lsp-progress')

local use_winbar = true

local statusline = { active = {}, inactive = {} }
local winbar = {}

-- remove dafault components
for _, v in ipairs({"a", "b", "c", "x", "y", "z"}) do
  local section = string.format("lualine_%s", v)
  statusline.active[section] = {}
  statusline.inactive[section] = {}
end

local winwidth = vim.fn.winwidth

-- Insert component at section {a, b, c, x, y, z}
local function insert(section, component)
  local section = string.format("lualine_%s", section)
  table.insert(statusline.active[section], component)
end

if use_winbar then
  winbar.active = {
    lualine_a = {
      {
        'filename',
        icon = "",
        path = 1,
        -- file_status = false,
      },
    },
    lualine_c = {
      { function() return "" end, draw_empty = true, }
    },
  }
  winbar.inactive = {
    lualine_c = {
      -- the centering trick doesn't work here
      {
        'filename',
        icons_enabled = true,
        icon = "",
        path = 1,
      },
    },
  }
  insert("a", {
    function() return " " end,
    padding = {},
  })
else
  insert("a", {
    'filename',
    icon = "",
    path = 1,
  })
  statusline.inactive.lualine_c = {
    -- Dummy component that centers the subsequent section.
    { function() return "%=" end, },
    {
      'filename',
      icons_enabled = true,
      icon = "",
      path = 1,
    },
  }
end

insert("b", {
  'filetype',
  icons_enabled = true,
  colored = false,
  cond = function() return winwidth(0) > 73 end,
})

insert("c", {
  function() return use_winbar and "%m%r%w" or "" end,
  padding = {},
})

-- default component has too much space around it
insert("c", {
  function ()
    return "%l:%c"
  end,
  icon = "",
  cond = function() return winwidth(0) > 80 end,
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
  lsp_progress.progress,
  -- function()
  --   local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  --   if #clients == 1 then
  --     return string.sub(clients[1].name, 1, 1)
  --   end
  --   local names = vim.tbl_map(function(client)
  --     return client.name
  --   end, clients)
  --   return table.concat(names, ", ")
  -- end,
  -- icon = "",
  -- cond = function()
  --   return #vim.lsp.get_active_clients({ bufnr = 0 }) > 0 and winwidth(0) > 63
  -- end,
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
  'b:gitsigns_head',
  icon = "",
})

insert("y", {
  'encoding',
  icons_enabled = false,
  cond = function()
    -- Bring more attention by only displaying when not utf-8
    return vim.opt.encoding:get() ~= "utf-8" and vim.fn.winwidth(0) > 53
  end,
})

insert("y", {
  'fileformat',
  icons_enabled = false,
  cond = function()
    -- Bring more attention by only displaying when not unix
    return vim.opt.fileformat:get() ~= "unix" and vim.fn.winwidth(0) > 46
  end,
})

insert("z", {
  function() return " " end,
  padding = {},
})

return {{
  'nvim-lualine/lualine.nvim', config = function()
    require("lualine").setup {
      options = {
        -- I assume the theme will configure lualine_c and x sections sensibly.
        theme = "auto",
        component_separators = "",
        section_separators = "",
        globalstatus = use_winbar,
      },
      sections = statusline.active,
      inactive_sections = statusline.inactive,
      tabline_section = {
        lualine_a = {
          'filename',
          path = 2,
        }
      },
      winbar = winbar.active,
      inactive_winbar = winbar.inactive,
    }
  end
}}
