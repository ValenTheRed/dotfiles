-- Switch off diagnostics signs in the sign column.
-- github issue: https://github.com/neovim/neovim/issues/15770
-- :help diagnostic-handlers-example
-- vim.diagnostic.handlers.signs = {
--   show = false,
-- }
vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
  },
  signs = false,
  float = {
    source = "always",
  }
}
