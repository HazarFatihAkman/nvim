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
	{
		"williamboman/mason.nvim",
		lazy = false,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-tool-installer").setup({
				ensure_installed = { "clangd", "codelldb" },
				run_on_start = false,
			})
		end,
	},
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("hazarfatihakman.configs.lsp")
    end
  },
}
