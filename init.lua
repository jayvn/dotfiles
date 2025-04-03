-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    -- add your plugins here
    --  'folke/tokyonight.nvim',
	
  spec = {
    { "Mofiqul/dracula.nvim", name = "dracula", priority = 1000 }, -- Add Dracula plugin
  -- LSP / Mason
  {
    'williamboman/mason.nvim',
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
    config = function()
      require("mason").setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require("mason-lspconfig").setup()
    end
  }, -- Ensure Mason runs first and setup is called
		{"mfussenegger/nvim-dap",
    "jay-babu/mason-nvim-dap.nvim"},

  -- Treesitter (Syntax Highlighting, etc.)
  {
    'nvim-treesitter/nvim-treesitter',
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate", -- Command to install/update parsers
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        indent = { enable = true },
        -- Add other Treesitter modules here as needed (e.g., textobjects, autotag)
      }
    end,
  },

  -- Utils / Tools
  { 'godlygeek/tabular', cmd = { "Tabularize", "Tab" } },
  { 'tpope/vim-surround', event = "VeryLazy" },
  { 'tpope/vim-commentary', event = "VeryLazy" },
  { 'tpope/vim-fugitive', event = "VeryLazy", cmd = "Git" }, -- Load on command or later
  { 'airblade/vim-gitgutter'}, -- Git diff in gutter
  { 'jalvesaq/Nvim-R', ft = { "r", "rmd", "quarto" } }, -- Load on R related filetypes
  { 'idbrii/vim-mergetool', cmd = "Mergetool" }, -- Load when using mergetool command
  { 'mfussenegger/nvim-dap', cmd = { "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut", "DapTerminate" } }, -- Load on DAP commands

  -- Completion Engine (nvim-cmp) and Snippets (LuaSnip)
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- Source for LSP
      'hrsh7th/cmp-buffer', -- Source for buffer words
      'L3MON4D3/LuaSnip', -- Snippet engine
      'saadparwaiz1/cmp_luasnip', -- Source for snippets
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
        }),
        -- Add keybindings for completion here if desired
        -- Example:
        -- mapping = cmp.mapping.preset.insert({
        --   ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        --   ['<C-f>'] = cmp.mapping.scroll_docs(4),
        --   ['<C-Space>'] = cmp.mapping.complete(),
        --   ['<C-e>'] = cmp.mapping.abort(),
        --   ['<CR>'] = cmp.mapping.confirm({ select = true }),
        -- }),
      })
    end,
  },

  -- UI
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Optional: for icons
    config = function ()
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  },
  { 'rebelot/heirline.nvim', event = "VeryLazy", dependencies = { 'nvim-tree/nvim-web-devicons' } }, -- Load UI later
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },

  -- Diagnostics / Trouble
  {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Trouble uses icons
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
}
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "dracula" } }, 
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Set the colorscheme after lazy setup
vim.cmd([[colorscheme dracula]]) 

-- Alias LspInstall to MasonInstall for convenience
vim.api.nvim_create_user_command('LspInstall', 'MasonInstall', {})
