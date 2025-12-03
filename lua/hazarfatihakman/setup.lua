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

-- Bootstrap LuaRocks via hererocks (for Windows)
local hererocks_path = vim.fn.stdpath("data") .. "\\lazy-rocks"
local luarocks_bin = hererocks_path .. "\\bin\\luarocks.bat"

if vim.fn.empty(vim.fn.glob(luarocks_bin)) > 0 then
  print("Installing LuaRocks via Hererocks...")
  local hererocks_repo = "https://github.com/luarocks/hererocks.git"
  local hererocks_path_git = vim.fn.stdpath("data") .. "\\hererocks"

  -- Clone hererocks if missing
  if vim.fn.empty(vim.fn.glob(hererocks_path_git)) > 0 then
    vim.fn.system({ "git", "clone", hererocks_repo, hererocks_path_git })
  end

  -- Run hererocks to install LuaRocks
  vim.fn.system({
    "python",
    hererocks_path_git .. "\\hererocks.py",
    hererocks_path,
    "5.1",           -- Lua version
    "--libs", "all"  -- install all standard libs
  })
end

-- Add LuaRocks bin to PATH for Neovim
vim.env.PATH = hererocks_path .. "\\bin;" .. vim.env.PATH

require("lazy").setup({
  checker = { enabled = false },
  spec = {
    { import = "hazarfatihakman.plugins.main"},
    { import = "hazarfatihakman.plugins.telescope"},
    { import = "hazarfatihakman.plugins.lualine"},
    { import = "hazarfatihakman.plugins.theme"},
    { import = "hazarfatihakman.plugins.git"},
    { import = "hazarfatihakman.plugins.cmp"},
    { import = "hazarfatihakman.plugins.which_key"},
  }
})
