return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        sign_priority = 6,
        update_debounce = 100,
        current_line_blame = true,
      })
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gstatus", "Gblame", "Gdiff" },
  },
}
