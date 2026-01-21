local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  checker = { enabled = false },
  rocks = {
    enabled = false,
    hererocks = false,
  },
  spec = {
    { import = "hazarfatihakman.plugins.main_plugins" },
    { import = "hazarfatihakman.plugins.theme" },
    { import = "hazarfatihakman.plugins.telescope" },
    { import = "hazarfatihakman.plugins.lualine" },
    { import = "hazarfatihakman.plugins.git" },
    { import = "hazarfatihakman.plugins.which_key" },
    { import = "hazarfatihakman.plugins.treesitter" },
    { import = "hazarfatihakman.plugins.lsp" },
    { import = "hazarfatihakman.plugins.tools" },
  }
})

require("lualine").setup()

