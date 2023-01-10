local wiki_index = "~/wiki/index.md"

vim.keymap.set(
  "n", "<leader>ww", ":e " .. wiki_index .. "<CR>", {
    noremap = true, silent = true, desc = "open wiki's index file"
  }
)
