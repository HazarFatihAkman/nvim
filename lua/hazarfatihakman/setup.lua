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

-- Bootstrap LuaRocks via hererocks (for Windows and macOS/Linux)
local hererocks_path = vim.fn.stdpath("data") .. "/lazy-rocks"
-- Note: use correct path separator for the current OS
local path_sep = package.config:sub(1, 1)
local luarocks_bin = hererocks_path .. path_sep .. "bin" .. path_sep .. "luarocks"
-- On Windows, the bin is likely 'luarocks.bat', so we check for the directory instead
if path_sep == "\\" then
    luarocks_bin = hererocks_path .. path_sep .. "bin" .. path_sep .. "luarocks.bat"
end

local function bootstrap_luarocks()
    print("Installing LuaRocks via Hererocks...")
    local hererocks_repo = "https://github.com/luarocks/hererocks.git"
    local hererocks_path_git = vim.fn.stdpath("data") .. path_sep .. "hererocks"
    
    -- Clone hererocks if missing
    if vim.fn.empty(vim.fn.glob(hererocks_path_git)) > 0 then
        vim.fn.system({ "git", "clone", hererocks_repo, hererocks_path_git })
    end

    -- Determine the correct python executable ('python3' on macOS/Linux, 'python' sometimes on Windows/Other)
    local python_cmd = "python"
    
    -- Check if 'python3' is a better choice (common on macOS)
    if vim.fn.executable("python3") == 1 and vim.fn.executable("python") == 0 then
        python_cmd = "python3"
    end
    
    -- Run hererocks to install LuaRocks
    vim.fn.system({
        python_cmd,
        hererocks_path_git .. path_sep .. "hererocks.py",
        hererocks_path,
        "5.1",
        "--libs", "all"
    })
end

if vim.fn.empty(vim.fn.glob(luarocks_bin)) > 0 then
    bootstrap_luarocks()
end

-- Add LuaRocks bin to PATH for Neovim (use the determined path_sep)
vim.env.PATH = hererocks_path .. path_sep .. "bin;" .. vim.env.PATH

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
