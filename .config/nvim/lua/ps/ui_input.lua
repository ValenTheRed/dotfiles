local win_set_opt = function(win, name, value)
  -- So that a :vs/:sp/:new window won't inherit these options. With
  -- `vim.api.nvim_win_set_option()` they did. There's an argument to be made
  -- that the user shouldn't be doing this in the first place, but even so,
  -- I'd rather that they don't do weird stuff that the user won't expect.
  vim.api.nvim_set_option_value(name, value, { scope = "local", win = win })
end

vim.fn.sign_define("UIInputPromptPrefix", { text = "", texthl = "Type" })

vim.ui.input = function(opts, on_confirm)
  if not on_confirm and type(on_confirm) ~= "function" then
    vim.notify("input: on_confirm is required and must be a function", vim.log.levels.ERROR)
    return
  end

  local default = (opts and opts.default) and opts.default or ""
  local prompt = (opts and opts.prompt) and opts.prompt or "Input"

  local buf = vim.api.nvim_create_buf(false, true)
  if buf == 0 then
    vim.notify("input: could not create buffer", vim.log.levels.ERROR)
    on_confirm(nil)
    return
  end
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    row = -3,
    col = 0,
    -- width includes sign column (which is 2 char long from testing)
    width = math.max(#default + 5, 30) + 2,
    height = 1,
    zindex = 1,
    border = "rounded",
    title = prompt,
    noautocmd = true, -- just in case.
  })
  if win == 0 then
    vim.api.nvim_buf_delete(buf)
    vim.notify("input: could not create floating window", vim.log.levels.ERROR)
    on_confirm(nil)
    return
  end

  win_set_opt(win, "winhighlight", "Normal:Normal")
  win_set_opt(win, "number", false)
  win_set_opt(win, "relativenumber", false)
  win_set_opt(win, "colorcolumn", "")
  win_set_opt(win, "signcolumn", "yes") -- To deal with nvim-cmp#1700
  win_set_opt(win, "cursorline", false)
  win_set_opt(win, "wrap", false)

  if default ~= "" then
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, {default})
  end

  vim.fn.sign_place(0, "UIInput", "UIInputPromptPrefix", buf, { lnum = 1 })

  -- TODO: use WinLeave instead? Have to use one, otherwise callback might run
  -- twice, and we don't want that.
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    group = vim.api.nvim_create_augroup("custom_vim_ui_input", {clear=true}),
    callback = function()
      -- Not going to follow prompt buftype in accepting only the last line as
      -- input because I don't know how to move sign in sign column as the cursor
      -- position changes.
      local line = vim.trim(vim.fn.getbufoneline(buf, "1")) -- :h getbufline()
      vim.api.nvim_win_close(win, false)
      if line == "" or line == default then
        on_confirm(nil)
      else
        on_confirm(line)
      end
    end,
    desc = "close input when user moves cursor to other window/buffer or :quits",
  })

  -- :quit triggers BufLeave.
  vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
    callback = function() vim.cmd.quit() end,
    desc = "accept input"
  })
end
