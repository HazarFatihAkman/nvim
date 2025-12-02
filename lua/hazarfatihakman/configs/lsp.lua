local M = {}

local function on_attach(client, bufnr)
  if client.name == "clangd" then
    vim.keymap.set("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", { buffer = bufnr, desc = "Switch Source/Header" })
  end
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go To Definition" })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
end

M.setup = function()
  vim.lsp.config.clangd = {
    on_attach = on_attach,
    cmd = {
      "clangd",
      "--background-index",
      "--query-driver=C:\\msys64\\mingw64\\bin\\*",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
  }

  vim.lsp.enable({ "clangd" })
end

return M

