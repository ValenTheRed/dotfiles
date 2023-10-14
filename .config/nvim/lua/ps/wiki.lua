local dir = {
  notes = vim.fn.expand([[~/notes]]),
  todo = vim.fn.expand([[~/notes/todo.md]])
}

local function set_todos()
  local fname = dir.todo
  local today = vim.fn.strftime("%A, %d %b %Y")

  local lines = vim.fn.readfile(fname)

  -- NOTE: no error checking if top lines doesn't match the date.
  if lines[1] == "# " .. today then
    -- TODO: place cursor at lines#2 if it exists
    return
  end

  lines[1] = "# " .. today

  if #lines >= 2 then
    local blankline = -1
    for i, line in ipairs(lines) do
      if string.match(line, "^$") then
        blankline = i
        break
      end
    end

    table.remove(lines, blankline)
    table.insert(lines, 2, "")
  end

  vim.fn.setline(1, lines)
  -- vim.fn.writefile(lines, fname)
end

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("parse_todo_file", { clear=true }),
  pattern = dir.todo,
  callback = set_todos,
})
