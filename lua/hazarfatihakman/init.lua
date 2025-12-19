print("-- Hazar Fatih Akman Neovim File --")

print("- Remap loading -")

require("hazarfatihakman.configs.remap")

print("- Remap is loaded -")

print("- Plugins loading -")

require("hazarfatihakman.setup")

print("- Plugins are loaded -")

print("- Diagnostic config loading -")

vim.opt.number = true
vim.opt.relativenumber = true

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})

print("- Diagnostic configs loaded -")

