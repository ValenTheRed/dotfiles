vim.fn.sign_define("UIInputPromptPrefix", { text = "", texthl = "Type" })

vim.ui.input = function(opts, on_confirm)
  local buf = vim.api.nvim_create_buf(false, true)
  if buf == 0 then
    vim.notify("input: could not create buffer", vim.log.levels.ERROR)
    on_confirm(nil)
    return
  end
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  local win_width = 30
  if opts.default then
    win_width = math.max(#opts.default + 5, win_width)
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, {opts.default})
  end

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    row = -3, -- vim.fn.getcurpos() ?
    col = 0,
    -- width includes sign column (which is 2 char long from testing)
    width = win_width + 2,
    height = 1,
    zindex = 1,
    border = "rounded",
    title = opts.prompt and opts.prompt or "Input",
    noautocmd = true, -- just in case.
  })
  if win == 0 then
    vim.api.nvim_buf_delete(buf)
    vim.notify("input: could not create floating window", vim.log.levels.ERROR)
    on_confirm(nil)
    return
  end

  vim.api.nvim_win_set_option(win, "winhighlight", "Normal:Normal")
  vim.api.nvim_win_set_option(win, "number", false)
  vim.api.nvim_win_set_option(win, "relativenumber", false)
  vim.api.nvim_win_set_option(win, "colorcolumn", "")
  vim.api.nvim_win_set_option(win, "cursorline", false)
  vim.api.nvim_win_set_option(win, "wrap", false)

  vim.fn.sign_place(0, "UIInput", "UIInputPromptPrefix", buf, { lnum = 1 })

  local evaluate_input = function()
    -- Not going to follow buftype prompt in accepting only the last line as
    -- input because I don't know how to move sign as the cursor position
    -- changes.
    local line = vim.fn.getbufoneline(buf, "1") -- :h getbufline()
    line = vim.trim(line)

    vim.api.nvim_win_close(win, false)

    if line == "" or line == opts.default then
      on_confirm(nil)
    else
      on_confirm(line)
    end
  end

  -- TODO: use WinLeave instead? Have to use one, otherwise callback might run
  -- twice, and we don't want that.
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    group = vim.api.nvim_create_augroup("custom_vim_ui_input", {clear=true}),
    callback = evaluate_input,
    desc = "close input when user moves cursor to other window/buffer",
  })

  -- :quit triggers BufLeave.
  vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
    callback = function() vim.cmd.quit() end,
    desc = "accept input"
  })
end
