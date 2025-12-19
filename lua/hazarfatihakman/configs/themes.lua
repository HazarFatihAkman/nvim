return {
  "rose-pine/neovim",
  lazy = false,
  priority = 1000,
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      variant = "main",
      disable_background = true,
      disable_float_background = true,
      styles = {
        bold = true,
        italic = true,
      },
    })
    vim.cmd.colorscheme("rose-pine")
  end,
}
