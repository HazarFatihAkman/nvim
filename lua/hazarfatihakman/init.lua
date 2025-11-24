print("-- Hazar Fatih Akman Neovim File --")
----
print("- Remap loading -")

require("hazarfatihakman.remap")

print("- Remap is loaded -")

-----
print("- Plugins loading -")

-- Load plugins
require("hazarfatihakman.plugin_setup")

print("- Plugins are loaded -")

print("- Diagnostic config loading -")

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})

print("- Diagnostic configs loaded -")

