require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = { "help" },
  },
  autotag = {
    enable = true,
  },
  additional_vim_regex_highlighting = false,
}
