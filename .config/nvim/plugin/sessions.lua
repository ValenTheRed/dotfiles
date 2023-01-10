--[[
-- Make managing sessions easier by chucking all the session files in a
-- root directory.
--]]
local root = vim.fn.stdpath("state") .. "/sessions"
if vim.fn.isdirectory(root) == 0 then
  vim.cmd([[:!mkdir ]] .. root)
end

-- session_file returns absolute path to the session file.
local session_file = function()
  local str = string.gsub(vim.fn.getcwd(), "[:\\/]", "")
  return root .. "/" .. str
end

vim.api.nvim_create_user_command("Mksession", function(opts)
    local file = session_file()
    local bang = ""
    if vim.fn.filewritable(file) ~= 0 then
      bang = "!"
    end
    vim.cmd([[:mksession]] .. bang .. " " .. file)
  end, {
    desc = "create and store session file in directory: " .. root,
  }
)

vim.api.nvim_create_user_command("Ldsession", function(opts)
    local file = session_file()
    if vim.fn.filereadable(file) ~= 0 then
      vim.cmd([[:source ]] .. file)
    else
      print("No session file exists!")
    end
  end, {
    desc = "load session file in directory: " .. root,
  }
)

vim.api.nvim_create_user_command("Rmsession", function(opts)
    local file = session_file()
    local cmd = "rm"
    if vim.fn.has("win32") ~= 0 then
      cmd = "del"
    end
    if vim.fn.filereadable(file) ~= 0 then
      vim.cmd("silent !" .. cmd .. " " .. file)
    end
  end, {
    desc = "remove session file in directory: " .. root,
  }
)

vim.api.nvim_create_autocmd("UIEnter", {
  group = vim.api.nvim_create_augroup("notify_if_session_file_exists", {}),
  pattern = { "*" },
  callback = function()
    if vim.fn.filereadable(session_file()) ~= 0 then
      print("A session file exists!")
    end
  end,
})
