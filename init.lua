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

-- Set editor options
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard for yank/paste
vim.opt.tabstop = 2       -- Number of visual spaces per TAB
vim.opt.softtabstop = 2   -- Number of spaces TAB counts for in insert mode
vim.opt.shiftwidth = 2    -- Number of spaces to use for autoindent
vim.opt.expandtab = true  -- Use spaces instead of tabs

-- -----------------------------------------------------------------------------
-- Custom Options Section
-- -----------------------------------------------------------------------------

-- Enhanced Searching
vim.opt.hlsearch = true -- Highlight all search matches
vim.opt.incsearch = true -- Show search matches incrementally as you type
-- vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- Override ignorecase if search pattern has uppercase letters

-- Smoother Scrolling
vim.opt.scrolloff = 8 -- Keep 8 lines visible above/below cursor when scrolling
vim.opt.sidescrolloff = 8 -- Keep 8 columns visible left/right of cursor when scrolling horizontally

-- Persistent Undo
vim.opt.undofile = true -- Enable persistent undo
local undodir = vim.fn.stdpath('data') .. '/undodir'
-- Ensure the directory exists
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, 'p') -- Create parent directories if needed
end
vim.opt.undodir = undodir -- Set the undo directory

-- Better Command Line Experience
vim.opt.cmdheight = 1 -- Set command line height
vim.opt.showmode = false -- Hide default mode indicator (status line usually shows it)

-- -----------------------------------------------------------------------------
-- End Custom Options Section
-- -----------------------------------------------------------------------------

-- Setup lazy.nvim
require("lazy").setup({
  -- add your plugins here
  -- 'folke/tokyonight.nvim',

  spec = {
    -- Theme
    { "Mofiqul/dracula.nvim", name = "dracula", priority = 1000 },

    -- LSP / Mason / DAP
    {
      'williamboman/mason.nvim',
      cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
      config = function()
        require("mason").setup()
      end,
    },
    {
      'williamboman/mason-lspconfig.nvim',
      dependencies = { 'williamboman/mason.nvim' },
      config = function()
        require("mason-lspconfig").setup()
      end,
    },
    { 'mfussenegger/nvim-dap', cmd = { "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut", "DapTerminate" } }, -- Load on DAP commands
    { 'jay-babu/mason-nvim-dap.nvim', dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' } }, -- Needs mason and dap

    -- Treesitter (Syntax Highlighting, etc.)
    {
      'nvim-treesitter/nvim-treesitter',
      event = { "BufReadPost", "BufNewFile" },
      build = ":TSUpdate", -- Command to install/update parsers
      config = function()
        -- Basic Treesitter setup
        require('nvim-treesitter.configs').setup {
          highlight = { enable = true },
          indent = { enable = true },
          -- Other modules can be added here if needed later
        }
      end,
    },

    -- Utils / Tools
    { 'godlygeek/tabular', cmd = { "Tabularize", "Tab" } },
    { 'tpope/vim-surround', event = "VeryLazy" },
    { 'tpope/vim-commentary', event = "VeryLazy" },
    { 'tpope/vim-fugitive', event = "VeryLazy", cmd = "Git" }, -- Load on command or later
    {
      'mhinz/vim-signify',
      event = { "BufReadPost", "BufNewFile" }, -- Git diff signs, load on file open/create
      -- Rely on default behavior and events to enable signify
    },
    { 'jalvesaq/Nvim-R', ft = { "r", "rmd", "quarto" } }, -- Load on R related filetypes
    { 'idbrii/vim-mergetool', cmd = "Mergetool" },

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
    -- File Explorer
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- Recommended for icons
        "MunifTanjim/nui.nvim",
      }
    },

    -- UI



    {
      "folke/persistence.nvim",
      event = "BufReadPre", -- Load session management early
      opts = { -- Options for session saving
        options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" }
      },
      config = true -- Explicitly run setup with opts
    },
    { "folke/flash.nvim", event = "VeryLazy", opts = {} }, -- Enhanced jump motions
    {
      'goolord/alpha-nvim',
      event = 'VimEnter',
      dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Optional: for icons
      config = function ()
        -- Use default alpha dashboard theme
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
      end
    },
    { 'rebelot/heirline.nvim', event = "VeryLazy", dependencies = { 'nvim-tree/nvim-web-devicons' } }, -- Load UI later
    {
      'nvim-lualine/lualine.nvim',
      event = "VeryLazy",
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup()
      end,
    },
    {
      'nvim-telescope/telescope.nvim',
      event = "VimEnter", -- Load Telescope at startup
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        -- Add Telescope keymaps
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Telescope recent files (MRU)' }) -- Added recent/MRU files

      end,
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      config = function()
        require("which-key").setup({}) -- Add setup call if needed later
      end,
    },

    -- File Explorer
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- Recommended for icons
        "MunifTanjim/nui.nvim",
      }
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
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
      },
    }, -- Added missing comma here
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "dracula" } },
  -- automatically check for plugin updates
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "dracula" } }, -- Set install colorscheme
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Set the colorscheme after lazy setup
vim.cmd([[colorscheme dracula]]) -- Set Dracula theme

-- Alias LspInstall to MasonInstall for convenience
vim.api.nvim_create_user_command('LspInstall', 'MasonInstall', {})

-- Keymaps can be defined here or in separate files
-- vim.defer_fn(function() ... end, 0) -- Removed Telescope keymaps previously added for default alpha

-- Neo-tree toggle keymap
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Explorer NeoTree", noremap = true, silent = true })

vim.keymap.set('n', '<leader>ev', function()
  vim.cmd.edit(vim.fn.stdpath('config') .. '/init.lua')
end, { desc = 'Edit Neovim config (init.lua)' })

vim.keymap.set('n', '<leader>R', '<cmd>source $MYVIMRC<CR>', { desc = 'Reload Neovim config', noremap = true, silent = true })

vim.keymap.set('n', '<leader>S', function()
  require('persistence').load()
end, { desc = 'Load last session' })

-- Buffer navigation shortcuts
vim.keymap.set('n', ']b', ':bnext<CR>', { desc = 'Next buffer', silent = true })
vim.keymap.set('n', '[b', ':bprevious<CR>', { desc = 'Previous buffer', silent = true })
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Explorer NeoTree", noremap = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
