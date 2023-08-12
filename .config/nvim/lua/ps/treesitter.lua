require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = { "help" },
  },
  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = false,
    enable_close_on_slash = false,
  },
  additional_vim_regex_highlighting = false,
}
