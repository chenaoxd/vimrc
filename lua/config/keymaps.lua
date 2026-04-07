local map = vim.keymap.set
local opts = { silent = true }

map("n", "<Space>", "<Nop>", opts)

map("n", "0", "^", opts)
map("n", "^", "0", opts)

map("n", "gj", "j", opts)
map("n", "j", "gj", opts)
map("n", "gk", "k", opts)
map("n", "k", "gk", opts)

map("n", "<leader>w", "<cmd>w<cr>", opts)
map("n", "<leader>rr", "<cmd>edit!<cr>", opts)
map("n", "<leader>Q", "<cmd>q!<cr>", opts)
map("n", "<leader>sv", "<cmd>source $MYVIMRC<cr>", opts)
map("n", "<leader>nf", function()
  vim.cmd.edit(vim.fn.expand("%:p:h") .. "/")
end, { desc = "New file in current directory", silent = true })

map("n", "<leader>oo", "<C-w>o", opts)
map("n", "<leader>q", "<C-w>q", opts)
map("n", "<leader>h", "<C-w>h", opts)
map("n", "<leader>j", "<C-w>j", opts)
map("n", "<leader>k", "<C-w>k", opts)
map("n", "<leader>l", "<C-w>l", opts)
map("n", "<leader>i", "<C-w>k<C-w>q", opts)
map("n", "<leader>v", "<C-w>v", opts)

map("n", "<leader>nh", "<cmd>nohlsearch<cr>", opts)

map({ "n", "v" }, "<leader>y", '"+y', opts)
map("n", "<leader>Y", '"+yy', opts)
map({ "n", "v" }, "<leader>p", '"+p', opts)
map("n", "<leader>P", '"+P', opts)
map("n", "<leader>u", '"up', opts)

map("n", "<leader>tn", "<cmd>tabnew<cr>", opts)
map("n", "<leader>tm", ":tabmove ", opts)
map("n", "<leader>tc", "<cmd>tabclose<cr>", opts)
map("n", "<leader>to", "<cmd>tabonly<cr>", opts)

map("n", "<leader>ct", "cT(", opts)
map("n", "<leader>!w", "<cmd>w !sudo tee % >/dev/null<cr><cmd>edit!<cr>", opts)
map("n", "<leader>rg", function()
  Snacks.picker.grep()
end, { desc = "Project grep", silent = true })
map("n", "<leader>Lr", "<cmd>LspRestart<cr>", opts)

map("n", "<leader>ss", "<cmd>mksession! ~/.vimsession<cr>", opts)
map("n", "<leader>sl", "<cmd>source ~/.vimsession<cr>", opts)

map("n", "<leader>sa", "<cmd>set syntax=yaml.ansible<cr>", opts)
map("n", "<leader>sh", "<cmd>set syntax=helm<cr>", opts)
map("n", "<leader>st", "<cmd>set syntax=<cr>", opts)

map("n", "<F8>", "<cmd>DlvConnect localhost:33333<cr>", opts)
map("n", "<F9>", "<cmd>DlvToggleBreakpoint<cr>", opts)
map("n", "<F10>", "<cmd>DlvClearAll<cr>", opts)

map("i", "<C-a>", "<Home>", opts)
map("i", "<C-e>", "<End>", opts)
map("i", "<C-d>", "<Del>", opts)
map("i", "<C-k>", "<C-o>D", opts)
map("i", "<C-w>", "<C-o>db", opts)
