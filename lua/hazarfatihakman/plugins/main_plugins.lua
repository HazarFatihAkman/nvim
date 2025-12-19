return {
  "folke/lazy.nvim",
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        "clangd",
      },
      run_on_start = false
    },
  },
}
