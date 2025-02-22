-- Enable syntax highlighting
vim.cmd("syntax on")

-- Show matching brackets
vim.opt.showmatch = true
vim.opt.number = true

-- Set indentation settings
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
-- change default leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  { "williamboman/mason-lspconfig.nvim" },
  { "windwp/nvim-autopairs", config = true }, -- for autoclosing of brackets
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Autocompletion
  { "hrsh7th/nvim-cmp" },        -- Completion plugin
  { "hrsh7th/cmp-nvim-lsp" },    -- LSP source for nvim-cmp
  { "L3MON4D3/LuaSnip" },      
})

-- NvimTree config
require("nvim-tree").setup()
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- Treesitter config
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "python", "javascript", "html", "css", "c", "cpp", "dart" }, -- Languages to install
  highlight = { enable = true },  -- Enable syntax highlighting
  indent = { enable = true },     -- Enable better indentation
  incremental_selection = { enable = true },
  textobjects = { enable = true },
})

-- autopair setup
require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt", "vim" },  -- Don't pair in certain file types
  enable_check_bracket_line = false,  -- Allow multiple brackets on the same line
  check_ts = true,  -- Use Treesitter for better pairing
  fast_wrap = {},  -- Enable wrapping shortcuts
})

-- Mason Config
require("mason").setup()
require("mason-lspconfig").setup()

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

-- Auto-completion Setup
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
})

vim.cmd("colorscheme kanagawa-wave")
