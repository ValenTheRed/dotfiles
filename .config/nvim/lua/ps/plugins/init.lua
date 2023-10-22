return {
  -- {{{ psmdc.nvim
  {
    'ValenTheRed/psmdc.nvim', config = function()
      vim.cmd.colorscheme("psmdc_dark")
    end,
    priority = 1000,
    dir = "F:/Github/psmdc.nvim", dev = true,
  }, -- }}}
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-dispatch',
  'danro/rename.vim',
  'godlygeek/tabular',
  'Vimjas/vim-python-pep8-indent',
  'wlangstroth/vim-racket',
  'nvim-tree/nvim-web-devicons',
  -- {{{ oil.nvm
  {
    'stevearc/oil.nvim', config = function()
      require("oil").setup {
        default_file_explorer = true,
        buf_options = {
          buflisted = false,
          bufhidden = "hide",
        },
        columns = {
          "icon",
        },
      }
    end
  }, -- }}}
  -- {{{ nvim-colorizer.lua
  {
    'norcalli/nvim-colorizer.lua', config = function()
      require('colorizer').setup()
    end
  }, -- }}}
  -- {{{ indent-blankline.nvim
  {
    'lukas-reineke/indent-blankline.nvim', config = function()
      require("indent_blankline").setup({
        char = "│",
        filetype_exclude = {"help", "markdown", "vimwiki"},
        buftype_exclude = {"terminal"},
      })
    end
  }, -- }}}
  --{{{ nvim-ts-autotag
  {
    'windwp/nvim-ts-autotag', config = function()
      require("nvim-ts-autotag").setup {
        enable = true,
        enable_rename = true,
        enable_close = false,
        enable_close_on_slash = false,
      }
    end,
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  }, --}}}
  --{{{ nvim-treesitter
  {
    'nvim-treesitter/nvim-treesitter', config = function()
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
          disable = { "help" },
        },
        additional_vim_regex_highlighting = false,
      }
    end, build = ':TSUpdate'
  }, --}}}
  'L3MON4D3/LuaSnip',
}
-- vim: set fdm=marker:
