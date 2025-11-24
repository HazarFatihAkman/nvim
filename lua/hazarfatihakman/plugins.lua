return {
	{
		"folke/lazy.nvim",
	},
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
	{ "nvim-lua/plenary.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
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
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
				}),
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local lspconfig = require("lspconfig")

			lspconfig.clangd.setup({
				cmd = {
					"clangd",
					"--background-index",
					"--query-driver=C:\\msys64\\mingw64\\bin\\*",
					"--clang-tidy",
					"--header-insertion=iwyu",
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local buf = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client.name == "clangd" then
						vim.keymap.set("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", { buffer = buf, desc = "Switch Source/Header" })
					end
				end,
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"jay-babu/mason-nvim-dap.nvim",
		},
		keys = {
			{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
			{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
			{ "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
			{ "<leader>dE", function() require("dapui").eval() end, desc = "Evaluate" },
			{ "<leader>de", function() require("dapui").toggle() end, desc = "Toggle UI" },
			{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
			{ "<leader>dS", function() require("dap").session() end, desc = "Session" },
			{ "<leader>ds", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
			{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
			{ "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()
			require("nvim-dap-virtual-text").setup()

			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

			require("mason-nvim-dap").setup({
				ensure_installed = { "codelldb" },
				automatic_setup = true,
				handlers = {
					codelldb = function(config)
						dap.adapters.codelldb = {
							type = "server",
							host = "localhost",
							port = "${port}",
							executable = {
								command = require("mason-registry").get_package("codelldb"):get_install_path() .. "/codelldb",
								args = { "--port", "${port}" },
							},
						}
					end,
				},
			})

			local executable_path = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end

			dap.configurations.c = {
				{
					name = "Launch file (C)",
					type = "codelldb",
					request = "launch",
					program = executable_path,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					runInTerminal = true,
				},
			}

			dap.configurations.cpp = vim.tbl_deep_extend("force", dap.configurations.c, {
				name = "Launch file (C++)",
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	}, 
}
