local nmap = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    noremap = true, silent = true, desc = desc,
  })
end

-- Switch off diagnostics signs in the sign column.
-- github issue: https://github.com/neovim/neovim/issues/15770
-- :help diagnostic-handlers-example
-- vim.diagnostic.handlers.signs = {
--   show = false,
-- }
local M = {}

vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
  },
  signs = false,
  float = {
    source = "always",
  }
}

-- Diagnostic signs
M.icons = { error = " ", warn = " ", info = " ", hint = "󰌵 " }

-- set icon and text highlight for diagnostic signs
for type, icon in pairs(M.icons) do
  local title_case = string.upper(string.sub(type, 1, 1)) .. string.sub(type, 2)
  local hl = "DiagnosticSign" .. title_case
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
end

-- d- is the same as d1k. So useless and available to map.
nmap("d-", function()
  vim.diagnostic.open_float({ scope = "line", source = true })
end, "open line diagnostics in a floating window")
nmap("dl", vim.diagnostic.setloclist, "vim.diagnostic.setloclist")
nmap("[d", vim.diagnostic.goto_prev, "jump to previous diagnostic in buffer")
nmap("]d", vim.diagnostic.goto_next, "jump to next diagnostic in buffer")

return M
