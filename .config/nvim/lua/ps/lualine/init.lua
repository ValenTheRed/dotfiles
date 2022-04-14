local options = {
  -- I assume the theme will configure lualine_c and x sections sensibly.
  theme = "auto",
  icons_enabled = false,
  component_separators = "",
  section_separators = "",
}

local eviline = require("ps.lualine.eviline")
require("lualine").setup {
  options = options,
  sections = eviline.sections,
  inactive_sections = eviline.inactive_sections,
  tabline_section = {
    lualine_a = {
      'filename',
      path = 2,
    }
  }
}
