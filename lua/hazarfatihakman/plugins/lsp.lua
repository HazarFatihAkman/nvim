return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("clangd", {
        capabilities = capabilities,
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--completion-style=detailed" },
      })

      vim.lsp.config("jdtls", {
        capabilities = capabilities,
        root_markers = { "settings.gradle", "settings.gradle.kts", "build.gradle.kts", "mvnw", "gradlew", "pom.xml", "build.gradle", ".git" },
      })

      vim.lsp.config("vtsls", {
        capabilities = capabilities,
        settings = {
          typescript = {
            updateImportsOnRename = "always",
            suggest = {
              completeFunctionCalls = true,
            }
          }
        }
      })

      vim.lsp.config("tailwindcss", {
        capabilities = capabilities,
      })

      vim.lsp.config("eslint", {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

    end,
  },
}
