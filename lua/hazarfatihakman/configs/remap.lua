vim.g.mapleader = " "

-- Folder & File Remap
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'Exit file' })
vim.keymap.set("n", "<leader>e", ':e ', { desc = 'Start :e command' })

-- Tab

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
