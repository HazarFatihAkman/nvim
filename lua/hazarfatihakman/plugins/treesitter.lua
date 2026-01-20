return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "cpp",
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css", 
        "json",
        "lua",
        "vim",
        "vimdoc"
      },
      highlight = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
    },
  }
}
