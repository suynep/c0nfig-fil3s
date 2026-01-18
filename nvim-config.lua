-- Enable syntax highlighting
vim.cmd("syntax on")

-- Show matching brackets
vim.opt.showmatch = true
vim.opt.number = true

-- timeout disable for smooth navigation
vim.opt.timeoutlen=300
vim.opt.ttimeoutlen=10

-- Set indentation settings
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.smartindent = true

-- change default leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- yank to clipboard
vim.opt.clipboard = "unnamedplus"

-- set max pop up height (mainly for autocompletion menu)
vim.o.pumheight = 5 

-- Set up Lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load Lazy.nvim
require("lazy").setup({
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "folke/tokyonight.nvim" }, -- Theme
  { "rebelot/kanagawa.nvim" }, -- Theme
  { "nyoom-engineering/oxocarbon.nvim" }, -- Theme
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  { "williamboman/mason-lspconfig.nvim" },
  { "windwp/nvim-autopairs", config = true }, -- for autoclosing of brackets
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  
  -- Formatting of Programmin Files
  {
    'stevearc/conform.nvim',
    opts = {},
  },

  -- Autocompletion
  { "hrsh7th/nvim-cmp" },        -- Completion plugin
  { "hrsh7th/cmp-nvim-lsp" },    -- LSP source for nvim-cmp
  { "L3MON4D3/LuaSnip" },      
  { "mattn/emmet-vim" }, -- this is for enabling emmet mode
  { "kepano/flexoki" },

  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
  { "mfussenegger/nvim-dap" }
})

-- NvimTree config
require("nvim-tree").setup()
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- Treesitter config
-- require("nvim-treesitter.configs").setup({
--   ensure_installed = { "lua", "python", "javascript", "html", "css", "c", "cpp", "dart" }, -- Languages to install
--   highlight = { enable = true },  -- Enable syntax highlighting
--   indent = { enable = true },     -- Enable better indentation
--   incremental_selection = { enable = true },
--   textobjects = { enable = true },
-- })

-- autopair setup
require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt", "vim" },  -- Don't pair in certain file types
  enable_check_bracket_line = false,  -- Allow multiple brackets on the same line
  check_ts = true,  -- Use Treesitter for better pairing
  fast_wrap = {},  -- Enable wrapping shortcuts
})

-- Mason Config
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "rust_analyzer", "pyright", "dartls", "bashls", "gopls" },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Load LSP configuration
local lspconfig = require("lspconfig")

-- Python LSP
lspconfig.pyright.setup({})

-- Configuration for Dart LSP
lspconfig.dartls.setup({
  cmd = { "dart", "language-server" },
  filetypes = { "dart" },
  root_dir = function(fname)
    local project_root = lspconfig.util.root_pattern("pubspec.yaml")(fname)
    return project_root or vim.fn.getcwd()  -- Always fallback to current directory
  end,
})

lspconfig.bashls.setup({
  filetypes = { "sh", "bash", "zsh" },
})

lspconfig.gopls.setup({
  filetypes = {"go"},
})


lspconfig.rust_analyzer.setup({
	  capabilities = capabilities,
})

lspconfig.emmet_language_server.setup({
  filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
  -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
  -- **Note:** only the options listed in the table are supported.
  init_options = {
    ---@type table<string, string>
    includeLanguages = {},
    --- @type string[]
    excludeLanguages = {},
    --- @type string[]
    extensionsPath = {},
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
    preferences = {},
    --- @type boolean Defaults to `true`
    showAbbreviationSuggestions = true,
    --- @type "always" | "never" Defaults to `"always"`
    showExpandedAbbreviation = "always",
    --- @type boolean Defaults to `false`
    showSuggestionsAsSnippets = false,
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
    syntaxProfiles = {},
    --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
    variables = {},
  },
})


-- AutoFormatting Setup based on conform.nvim
require("conform").setup({
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 1000,
  },
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    dart = { "dart_format" },
    html = { "prettier" },
    css = { "prettier" },
    go = { "gofmt" },
    rust = { "rustfmt" },
  },
})


-- Auto-completion Setup
local cmp = require("cmp")
cmp.setup({
  window = {
    completion = {
      max_width = 40,  -- Adjust this number to your preference (default is around 80)
      max_height = 10,
    },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
})


vim.cmd("colorscheme kanagawa-dragon")
-- vim.api.nvim_set_hl(0, "Visual", { bg = "#00ffff", fg = "NONE", blend = 90 })


-- custom keybinds

-- vim.keymap.set("n", "<C-]>", function()
--     -- Open a new tab
--     vim.cmd("tab split")
--     -- Jump to the definition using the LSP function
--     vim.lsp.buf.definition()
-- end, { noremap = true, silent = true, desc = "Go to definition in a new tab" })
