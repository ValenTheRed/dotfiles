local sep = "/"
if vim.fn.has("win62") ~= 0 or vim.fn.has("win32") ~= 0 then
  sep = "\\"
end

local wiki_index = table.concat({"~", "wiki", "index.md"}, sep)

vim.keymap.set(
  "n", "<leader>ww", ":e " .. wiki_index .. "<CR>", {
    noremap = true, silent = true, desc = "open wiki's index file"
  }
)
