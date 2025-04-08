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
vim.opt.scrolloff = 999 -- Keep cursor centered vertically when possible
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
      opts = {
        -- Ensure these LSP servers are installed
        ensure_installed = {
          "pyright",
          "r_language_server", -- Corrected name
        },
      },
      config = function(_, opts)
        require("mason-lspconfig").setup(opts)
      end,
    },
    { 'mfussenegger/nvim-dap', cmd = { "DapContinue", "DapStepOver", "DapStepInto", "DapStepOut", "DapTerminate" } }, 
    { 'jay-babu/mason-nvim-dap.nvim', dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' } },
    {
      -- LSP Configuration
      'neovim/nvim-lspconfig',
      dependencies = {
        'williamboman/mason.nvim', -- Ensure mason is loaded first
        'williamboman/mason-lspconfig.nvim',
      },
      config = function()
        local lspconfig = require('lspconfig')
        local capabilities = require('cmp_nvim_lsp').default_capabilities() -- Get capabilities from nvim-cmp

        -- Helper function for smart Ctrl+] behavior
        local function smart_definition_or_references()
          local start_buf = vim.fn.bufnr('%')
          local start_lnum = vim.fn.line('.')
          -- Try to go to definition first
          vim.lsp.buf.definition()
          -- Use defer_fn to wait briefly for potential cursor movement
          vim.defer_fn(function()
            local end_buf = vim.fn.bufnr('%')
            local end_lnum = vim.fn.line('.')
            -- If buffer and line number haven't changed, assume we were on the definition
            -- and show references instead.
            if start_buf == end_buf and start_lnum == end_lnum then
              vim.lsp.buf.references()
            end
          end, 50) -- Wait 50ms
        end

        -- Define a common on_attach function for LSP keybindings
        local on_attach = function(client, bufnr)
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('keep', bufopts, { desc = 'LSP Go to Declaration' }))
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('keep', bufopts, { desc = 'LSP Go to Definition' }))
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('keep', bufopts, { desc = 'LSP Hover Documentation' }))
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('keep', bufopts, { desc = 'LSP Go to Implementation' }))
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('keep', bufopts, { desc = 'LSP Signature Help' }))
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('keep', bufopts, { desc = 'LSP Add Workspace Folder' }))
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('keep', bufopts, { desc = 'LSP Remove Workspace Folder' }))
          vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, vim.tbl_extend('keep', bufopts, { desc = 'LSP List Workspace Folders' }))
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, vim.tbl_extend('keep', bufopts, { desc = 'LSP Go to Type Definition' }))
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('keep', bufopts, { desc = 'LSP Rename Symbol' }))
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('keep', bufopts, { desc = 'LSP Code Action' }))
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('keep', bufopts, { desc = 'LSP Go to References' }))
          vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, vim.tbl_extend('keep', bufopts, { desc = 'LSP Format Buffer' }))

          -- Add completion capabilities if nvim-cmp is used
          if client.server_capabilities.completionProvider then
            bufopts.desc = "Trigger completion"
            vim.keymap.set("i", "<C-Space>", vim.lsp.buf.completion, bufopts)
          end
        end

        -- Setup Python LSP (pyright)
        lspconfig.pyright.setup({
          capabilities = capabilities,
          on_attach = on_attach,
        })

        -- Setup R LSP (r_language_server)
        lspconfig.r_language_server.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            r = {
              lsp = {
                debug = false,
                log_level = "error",
                rich_documentation = true,
              },
              rpath = {
                vim.fn.expand("$PWD/packages"),
              },
              source = {
                global_source = vim.fn.expand("$PWD/globals.R"),
              },
            },
          },
          flags = {
            debounce_text_changes = 150,
          },
        })

      end,
    },
    {
      'nvim-treesitter/nvim-treesitter',
      event = { "BufReadPost", "BufNewFile" },
      build = ":TSUpdate", 
      config = function()
        require('nvim-treesitter.configs').setup {
          highlight = { enable = true },
          indent = { enable = true },
        }
      end,
    },

    -- Utils / Tools
    { 'godlygeek/tabular', cmd = { "Tabularize", "Tab" } },
    { 'tpope/vim-surround', event = "VeryLazy" },
    { 'tpope/vim-commentary', event = "VeryLazy" },
    { 'romainl/vim-cool', event = "VeryLazy" }, -- Automatically clear search highlight on cursor move
    { 'tpope/vim-fugitive', event = "VeryLazy", cmd = "Git" },
    {
      'mhinz/vim-signify',
      event = { "BufReadPost", "BufNewFile" }, 
    },
    { 'jalvesaq/Nvim-R', ft = { "r", "rmd", "quarto" } },
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
      },
      config = function()
        require("neo-tree").setup({
          filesystem = {
            follow_current_file = { 
              enabled = true,
            },
          },
        })
      end,
    },

    -- UI

    {
      "folke/persistence.nvim",
      event = "VimEnter", -- Load plugin on startup
      opts = { -- Add options for autosaving
        autosave = { save_on_quit = true }
      },
      config = true -- Explicitly run setup with opts
    },
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
        require('lualine').setup({
          sections = {
            lualine_c = {{'filename', path = 1}}, -- Set path = 1 for relative path
          },
          inactive_sections = {
            lualine_c = {{'filename', path = 1}}, -- Also show relative path in inactive windows
          },
          tabline = {
             lualine_a = {'buffers'},
          },
          extensions = {'neo-tree', 'trouble'} 
        })
      end,
    },
    {
      'nvim-telescope/telescope.nvim',
      event = "VimEnter", 
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        -- Add Telescope keymaps
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Telescope recent files (MRU)' }) 
        vim.keymap.set('n', '<leader>ft', builtin.tags, { desc = 'Telescope tags' }) 

      end,
    },
    { "folke/which-key.nvim", event = "VeryLazy" },

    -- File Explorer
    {
      "nvim-neo-tree/neo-tree.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- Recommended for icons
        "MunifTanjim/nui.nvim",
      }
    },

    { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {}, event = "VeryLazy" }, -- TODO/WARN highlight
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


vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = "Explorer NeoTree", noremap = true, silent = true })

vim.keymap.set('n', '<leader>ev', function()
  vim.cmd.edit(vim.fn.stdpath('config') .. '/init.lua')
end, { desc = 'Edit Neovim config (init.lua)' })

vim.keymap.set('n', '<leader>S', function()
end, { desc = 'Edit Neovim config (init.lua)' })

-- Buffer navigation shortcuts
vim.keymap.set('n', ']b', ':bnext<CR>', { desc = 'Next buffer', silent = true })
vim.keymap.set('n', '[b', ':bprevious<CR>', { desc = 'Previous buffer', silent = true })

-- Keep search direction consistent (n forward, N backward)
vim.keymap.set('n', 'n', "v:searchforward ? 'n' : 'N'", { expr = true, noremap = true, silent = true, desc = 'Next search result (always forward)' })
vim.keymap.set('n', 'N', "v:searchforward ? 'N' : 'n'", { expr = true, noremap = true, silent = true, desc = 'Previous search result (always backward)' })


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

-- Automatically load session on startup if no file arguments are given
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  pattern = "*",
  nested = true,
  callback = function()
    -- Only load if started without arguments
    if vim.fn.argc() == 0 then
      require("persistence").load()
    end
  end,
})

-- TODO: 
-- The  tree explorer window should list changed files in git and list open buffers also as diffferent tabs
