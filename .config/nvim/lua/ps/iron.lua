local core = require("iron.core")

core.setup {
  config = {
    repl_open_cmd = 'botright 10split',
    repl_definition = {
      -- iron normalises windows line endings to unix. This is a problem in the
      -- `python` interpreter since, on windows, it uses windows line endings
      -- to move to the next line and execute previous, anything else doesn't
      -- work. `ipython` is also error prone. The normal line endings trigger
      -- multi-line and you need to either visually send the line ending for it
      -- to execute the previous lines or use iron's 'cr' keymap.
      python = {
        command = "ipython"
      },
      racket = {
        command = "racket"
      },
      lua = {
        command = "luajit"
      }
    }
  },

  -- If current file is a registered filetype, then using these keymaps would
  -- start a new repl if one doesn't already exists. I don't like that.
  keymaps = {
    send_motion = "<leader>s",
    visual_send = "R",
    -- send_file = "<leader>sf",
    send_line = "X",
    -- send_mark = "<leader>sm",
    -- mark_motion = "<leader>mc",
    -- mark_visual = "<leader>mc",
    remove_mark = "<leader>sd",
    cr = "<leader>s<cr>",
    interrupt = "<leader>sc",
    exit = "<leader>sq",
    clear = "<leader>sl",
  },

  -- disable default highlight
  highlight = {}
}
