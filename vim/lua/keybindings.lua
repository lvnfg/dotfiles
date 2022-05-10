local map = vim.keymap.set


-- Tab completion
map('i', '<Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-N>' or '<Tab>'
end, {expr = true})
map('i', '<S-Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-p>' or '<C-h>'
end, {expr = true})

-- Closing & saving buffers & windows
map('n', '<M-q>', ':q<cr>')                 -- Close window
map('n', '<M-w>', ':lua CloseBuffer()<cr>') -- Call function close buffer
map('n', '<M-s>', ':w<cr>')                 -- Save file
map('n', '<M-S>', ':lua SaveAs()<cr>')      -- Call SaveAs
map('n', '<M-r>', ':lua RefreshAll()<cr>')  -- Call RefreshAll()

-- Fzf
map('n', '<M-f>', ':Files<cr>')             -- Invoke Fzf
-- Git
map('n', '<M-g>', ':GFiles?<cr>')           -- Fzf list git status for all files
map('n', '<M-c>', ':BCommits<cr>')          -- Fzf list git commit for this buffer
map('n', '<M-C>', ':Commits<cr>')           -- Fzf list git commit for entire repo
-- Buffer management
map('n', '<M-b>', ':Buffers<cr>')           -- Fzf list all buffers

-- Navigation
map('n', '<C-h>', ':bprevious<cr>')         -- Show previous buffer in current window
map('n', '<C-l>', ':bnext<cr>')             -- Show next buffer in current window
-- Tmux integrated movement
map('n', '<M-h>', ':TmuxNavigateLeft<cr>')
map('n', '<M-j>', ':TmuxNavigateDown<cr>')
map('n', '<M-k>', ':TmuxNavigateUp<cr>')
map('n', '<M-l>', ':TmuxNavigateRight<cr>')
-- Split window
map('n', '<M-H>', ':aboveleft vsplit<cr>')
map('n', '<M-J>', ':split<cr>')
map('n', '<M-K>', ':leftabove split<cr>')
map('n', '<M-L>', ':belowright vsplit<cr>')
-- Resize split
map('n', '<M-Left>',  ':vertical resize -5<cr>')
map('n', '<M-Down>',  ':resize -5<cr>')
map('n', '<M-Up>',    ':resize +5<cr>')
map('n', '<M-Right>', ':vertical resize +5<cr>')

-- Misc
map('n', '<Esc>', ':noh<cr>') 	-- Toggle no highlight with Esc
