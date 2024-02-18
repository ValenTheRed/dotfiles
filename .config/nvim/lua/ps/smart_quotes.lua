-- Rules
-- 1. \s+<single quote>(?=\d)
--    convert to closing single quote. e.g. ’90s.
-- 2. \s+<quote>
--	  convert to opening quote
-- 3. [^\s]<quote>
--    convert to closing quote
--
-- Last two rules have been implemented, first has been left out since it's use
-- seems niche.
--
-- Limitations/Unexpected behaviour –
-- 1. with LunarWatcher/auto-pairs: this plugin doesn't insert auto-pairs using
-- InsertCharPre, it does it's own thing. From observing it's behaviour, it
-- intercepts `v:char` before InsertCharPre and figures out whether it needs to
-- run or not. If yes, then it waits for `v:char` to insert and then appends
-- another `v:char` in a way that triggers InsertCharPre again but not
-- auto-pairs. So, if v:char is modified inbetween (say 'a'), they the modified
-- value (i.e. 'a') is inserted again.

local prev_char = function()
	-- charcol uses 1-indexing and strcharpart uses 0-indexing, hence
	-- substraction by 2.
	local col = vim.fn.charcol(".") - 2
	local c = ""
	if col ~= -1 then
		c = vim.fn.strcharpart(vim.api.nvim_get_current_line(), col, 1)
	end
	return c
end

vim.api.nvim_create_autocmd("InsertCharPre", {
	group = vim.api.nvim_create_augroup("smart_quotes", { clear = true }),
	pattern = "*.md",
	callback = function()
		-- ‘ ’ “ ”
		if vim.v.char == [["]] then
			vim.v.char = string.find(prev_char(), "%S") ~= nil and "”"
				or "“"
		elseif vim.v.char == [[']] then
			vim.v.char = string.find(prev_char(), "%S") ~= nil and "’"
				or "‘"
		end
	end,
})
