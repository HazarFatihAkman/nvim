return {
	-- The plugin manager itself is always the first entry
	--
	"folke/lazy.nvim",

	-- GitSigns
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" }, -- Loads when a file is read or written
		config = function()
			require("gitsigns").setup({
				sign_priority = 6,
				update_debounce = 100,
				current_line_blame = true, -- Shows blame for current line
			})
		end,
	},
	-- Vim-Fugitive
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "Gstatus", "Gblame", "Gdiff" },
	},
	-- Telescope
	{
		"nvim-lua/plenary.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false, -- load immediately
	},
	-- Mason
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"clangd", -- C/C++ Language Server Protocol (LSP)
				"codelldb", -- Debug Adapter for C/C++
			},
		},
		-- Configure LSP servers and formatters/linters
		config = function()
			require("mason-lspconfig").setup()
			require("mason-tool-installer").setup()
		end,
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim", -- Optional: for linters/formatters
		},
	},
	-- LSP Config
	-- nvim-cmp (completion engine)
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- lazy-load on insert
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",       -- LSP source
			"hrsh7th/cmp-buffer",         -- buffer completions
			"hrsh7th/cmp-path",           -- path completions
			"saadparwaiz1/cmp_luasnip",  -- snippets source
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
		dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local lspconfig = require("lspconfig")

			lspconfig.clangd.setup({
				cmd = { "clangd", "--background-index" },
				root_dir = require("lspconfig.util").root_pattern("compile_commands.json", ".git"),
				keys = {
					{ "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
				},
			})
		end,
	},
	-- Debugger
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui", -- UI for debugging panels
			"theHamsta/nvim-dap-virtual-text", -- Shows variable values inline
			"jay-babu/mason-nvim-dap.nvim", -- Auto-configures DAP adapters from Mason
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

			-- Setup DAP UI
			dapui.setup()

			-- Setup Virtual Text
			require("nvim-dap-virtual-text").setup()

			-- Listeners to manage DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- ** CodeLLDB Configuration **
			require("mason-nvim-dap").setup({
				ensure_installed = { "codelldb" },
				automatic_setup = true,
				handlers = {
					codelldb = function(config)
						require("dap").adapters.codelldb = {
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

			-- ** C/C++ Debug Configurations **
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
					runInTerminal = true, -- Crucial for IO operations
				},
			}

			dap.configurations.cpp = vim.tbl_deep_extend("force", dap.configurations.c, {
				name = "Launch file (C++)",
			})
		end,
	},

}
