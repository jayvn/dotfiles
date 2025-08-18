-- Enable Lua module cache for faster loading
vim.loader.enable()

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			"\nPress any key to exit...",
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set editor options
vim.opt.number = true
vim.opt.clipboard = "unnamedplus" -- Use system clipboard for yank/paste
vim.opt.tabstop = 2 -- Number of visual spaces per TAB
vim.opt.softtabstop = 2 -- Number of spaces TAB counts for in insert mode
vim.opt.shiftwidth = 2 -- Number of spaces to use for autoindent
vim.opt.expandtab = true -- Use spaces instead of tabs

-- -----------------------------------------------------------------------------
-- Custom Options Section
-- -----------------------------------------------------------------------------

-- Enhanced Searching
vim.opt.hlsearch = true -- Highlight all search matches
vim.opt.incsearch = true -- Show search matches incrementally as you type
vim.opt.ignorecase = true
vim.opt.smartcase = true -- Override ignorecase if search pattern has uppercase letters

-- Smoother Scrolling
vim.opt.scrolloff = 999 -- Keep cursor centered vertically when possible
vim.opt.sidescrolloff = 8 -- Keep 8 columns visible left/right of cursor when scrolling horizontally

-- Persistent Undo
vim.opt.undofile = true -- Enable persistent undo
local undodir = vim.fn.stdpath("data") .. "/undodir"

if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
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

	spec = {
		-- Theme
		-- 'folke/tokyonight.nvim',
		{ "ellisonleao/gruvbox.nvim", name = "gruvbox", priority = 1000, lazy = false },
		-- "tomasr/molokai", "ellisonleao/gruvbox.nvim",
		{
			"powerman/vim-plugin-AnsiEsc", -- helps with ^[ type of console outputs in file
			cmd = "AnsiEsc",
		},
		{ "akinsho/git-conflict.nvim", version = "*", event = "BufReadPre", config = true },
		{ "folke/snacks.nvim" },
		-- LSP / Mason / DAP
		{
			"williamboman/mason.nvim",
			cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
			event = "VeryLazy",
			config = function()
				require("mason").setup()
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "williamboman/mason.nvim" },
			tag = "v2.0.0-rc.1",
			event = { "BufReadPre", "BufNewFile" },
			opts = {
				ensure_installed = {
					"basedpyright", -- Python LSP Server with willRenameFiles support
					-- "pylint",
					"r_language_server",
					"yamlls",
					"azure_pipelines_ls",
					"jsonls",
					"lua_ls",
					"ruff", -- Add ruff to ensure it's installed by Mason
					"rust_analyzer", -- Rust LSP Server
					"bashls", -- Bash language server
				},
			},
			config = function(_, opts)
				require("mason-lspconfig").setup(opts)
			end,
		},
		{
			"stevearc/conform.nvim",
			event = "VeryLazy",
			cmd = { "ConformInfo" },
			dependencies = { "williamboman/mason.nvim" },
			opts = {
				formatters_by_ft = {
					python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
					r = { "styler" },
					lua = { "stylua" },
					bash = { "shfmt" },
					sh = { "shfmt" },
					zsh = { "shfmt" },
				},
				formatters = {
					styler = {
						inherit = false,
						command = "R",
						args = {
							"-s",
							"-e",
							"styler::style_file(commandArgs(TRUE), style = styler::tidyverse_style, scope = I(c('indention', 'spaces', 'tokens')), indent_by = 2)",
							"--args",
							"$FILENAME",
						},
						stdin = false,
					},
				},
				-- f
				-- format_on_save = false,
			},
			keys = {
				{
					"<leader>fm",
					function()
						require("conform").format({ async = true, lsp_fallback = true })
					end,
					mode = "",
					desc = "Format file (Conform)",
				},
			},
		},

		--
		{
			"lvimuser/lsp-inlayhints.nvim",
			dependencies = { "neovim/nvim-lspconfig" },
			event = "LspAttach",
			config = function()
				require("lsp-inlayhints").setup()
			end,
		},
		{ "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" } },
		{
			-- LSP Configuration
			"neovim/nvim-lspconfig",
			dependencies = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
			},
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				local lspconfig = require("lspconfig")
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities.textDocument.completion.completionItem.snippetSupport = true

				-- Define a common on_attach function for LSP keybindings
				local on_attach = function(client, bufnr)
					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
					end

					map("n", "gd", vim.lsp.buf.definition, "LSP Go to Definition")
					map("n", "K", vim.lsp.buf.hover, "LSP Hover Documentation")
					map("n", "<leader>D", vim.lsp.buf.type_definition, "LSP Go to Type Definition")
					map("n", "<leader>rn", vim.lsp.buf.rename, "LSP Rename Symbol")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP Code Action")
					map("n", "gr", vim.lsp.buf.references, "LSP Go to References")

					vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
				end

				-- Autocommand to attach inlay hints
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("LspAttach_inlayhints", { clear = true }),
					callback = function(args)
						if not (args.data and args.data.client_id) then
							return
						end
						local client = vim.lsp.get_client_by_id(args.data.client_id)
						if client and client.supports_method("textDocument/inlayHint") then
							-- Make sure you have the inlay hints plugin installed
							pcall(require("lsp-inlayhints").on_attach, client, args.buf)
						end
					end,
				})

				-- Configure basedpyright
				lspconfig.basedpyright.setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						basedpyright = {
							typeCheckingMode = "basic",
						},
						python = {
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "openFilesOnly",
							},
						},
					},
				})

				-- Configure jsonls
				lspconfig.jsonls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						json = {
							schemas = {
								{
									description = "Azure Pipelines schema",
									fileMatch = { "azure-pipelines.yml", "azure-pipelines.yaml" },
									url = "https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/main/service-schema.json",
								},
							},
							validate = { enable = true },
						},
					},
				})

				-- Configure r_language_server
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
				})

				-- Configure azure_pipelines_ls
				lspconfig.azure_pipelines_ls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})

				-- Configure lua_ls
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							workspace = {
								checkThirdParty = false,
							},
							telemetry = {
								enable = false,
							},
							diagnostics = {
								globals = { "vim" }, -- For init.lua file
							},
						},
					},
				})

				-- Configure rust_analyzer
				lspconfig.rust_analyzer.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})

				-- Configure bashls
				lspconfig.bashls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})

				-- Configure ruff
				-- lspconfig.ruff.setup({
				--  capabilities = capabilities,
				--  on_attach = on_attach,
				-- })
			end,
		},

		{
			"antosha417/nvim-lsp-file-operations",
			dependencies = { "nvim-lua/plenary.nvim", "nvim-neo-tree/neo-tree.nvim" },
			event = "VeryLazy",
			config = function()
				require("lsp-file-operations").setup()
			end,
		},

		{
			"nvim-treesitter/nvim-treesitter",
			event = { "BufReadPost", "BufNewFile" },
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = { "python", "lua", "vim", "r", "bash", "yaml", "markdown", "rust" },
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
					indent = { enable = true },
				})
			end,
		},
		{ "onsails/lspkind.nvim", event = { "VimEnter" } },
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			event = { "BufReadPost", "BufNewFile" },
			config = function()
				require("nvim-treesitter.configs").setup({
					textobjects = {
						textobjects = {
							select = {
								enable = true,
								lookahead = true,
							},
							-- keymaps = {
							--   ["af"] = "@function.outer",
							--   ["if"] = "@function.inner",
							--   ["ac"] = "@class.outer",
							--   ["ic"] = "@class.inner",
							-- },
							move = {
								enable = true,
								set_jumps = true,
								goto_next_start = {
									["]m"] = "@function.outer",
									["]]"] = "@class.outer",
								},
								goto_next_end = {
									["]M"] = "@function.outer",
									["]["] = "@class.outer",
								},
								goto_previous_start = {
									["[m"] = "@function.outer",
									["[["] = "@class.outer",
								},
								goto_previous_end = {
									["[M"] = "@function.outer",
									["[]"] = "@class.outer",
								},
							},
						},
					},
				})
			end,
		},

		-- Utils / Tools
		{ "godlygeek/tabular", cmd = { "Tabularize", "Tab" } },
		{
			"kylechui/nvim-surround",
			version = "*",
			event = "VeryLazy",
			config = function()
				require("nvim-surround").setup({})
			end,
		},
		{ "tpope/vim-commentary", event = "VeryLazy" },
		{ "romainl/vim-cool", event = "VeryLazy" }, -- Automatically clear search highlight on cursor move
		{ "tpope/vim-fugitive", event = "VeryLazy", cmd = "Git" },
		{ "mhinz/vim-signify" },
		{ "jalvesaq/Nvim-R", ft = { "r", "rmd", "quarto" }, lazy = true },
		{ "idbrii/vim-mergetool", cmd = "Mergetool" },
		{
			"f-person/git-blame.nvim",
			event = "BufReadPre",
			config = function()
				require("gitblame").setup({ enabled = true })
			end,
		},

		-- File Explorer
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			cmd = { "Neotree" },
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
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
		{

			"mechatroner/rainbow_csv",
			ft = {
				"csv",
				"tsv",
				"csv_semicolon",
				"csv_whitespace",
				"csv_pipe",
				"rfc_csv",
				"rfc_semicolon",
			},
			cmd = {
				"RainbowDelim",
				"RainbowDelimSimple",
				"RainbowDelimQuoted",
				"RainbowMultiDelim",
			},
		},

		-- UI

		{
			"folke/persistence.nvim",
			event = "VimEnter", -- Load plugin on startup
			opts = { -- Add options for autosaving
				autosave = { save_on_quit = true },
			},
			config = true, -- Explicitly run setup with opts
		},
		{
			"nvim-lualine/lualine.nvim",
			event = "VeryLazy",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("lualine").setup({
					sections = {
						lualine_c = { { "filename", path = 1 } }, -- 1 = relative path
					},
					inactive_sections = {
						lualine_c = { { "filename", path = 1 } }, -- Also show relative path in inactive windows
					},
					extensions = { "neo-tree", "trouble" },
				})
			end,
		},
		{
			"romgrk/barbar.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			event = "VeryLazy",
			init = function()
				vim.g.barbar_auto_setup = false
			end,
			opts = {
				animation = true,
			},
			version = "^1.0.0",
		},

		{
			"nvim-telescope/telescope.nvim",
			event = "VimEnter",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				-- Add Telescope keymaps
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
				vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
				vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
				vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Telescope recent files (MRU)" })
				vim.keymap.set("n", "<leader>ft", builtin.tags, { desc = "Telescope tags" })
				vim.keymap.set(
					"n",
					"<leader>fsd",
					builtin.lsp_document_symbols,
					{ desc = "Telescope LSP document symbols" }
				)
				-- builtin.lsp_workspace_symbols, doesn't work well cuz of lsp s
				vim.keymap.set("n", "<leader>fst", builtin.treesitter, { desc = "Telescope Treesitter symbols" })
				vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
				vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Telescope commands" })
			end,
		},
		{ "folke/which-key.nvim", event = "VeryLazy" },
		{
			"weilbith/nvim-code-action-menu",
			cmd = "CodeActionMenu",
		},

		{
			"nvim-treesitter/nvim-treesitter-context",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			event = { "BufReadPost", "BufNewFile" },
		},

		-- lazy.nvim
		{
			"folke/noice.nvim", -- messages UI (minimal )
			event = "VeryLazy",
			opts = {
				presets = {
					long_message_to_split = true, -- long messages will be sent to a split
					lsp_doc_border = true, -- add a border to hover docs and signature help (doesn't work ?)
				},
			},
			dependencies = {
				"MunifTanjim/nui.nvim",
				-- "rcarriga/nvim-notify", -use the notification view. (cant do echo copy then)
			},
		},

		{
			"mfussenegger/nvim-lint",
			event = { "BufWritePost", "BufReadPost" },
			config = function()
				require("lint").linters_by_ft = {
					linters_by_ft = {
						python = { "pyright", "pylint" },
						-- python = { 'ruff' }, -- Use ruff for linting Python. Note also uncomment * line in pyright config
						r = { "lintr" },
						lua = { "luacheck" },
						markdown = { "vale" },
					},
				}
			end,
		},

		{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {}, event = "VeryLazy" }, -- TODO/WARN highlight
		-- {
		-- 	"olimorris/codecompanion.nvim", --copilot meets zig ?
		-- 	dependencies = {
		-- 		"nvim-lua/plenary.nvim",
		-- 		"nvim-treesitter/nvim-treesitter",
		-- 	},
		-- 	-- cmd = { "CodeCompanion", "CodeCompanionOpen" },
		-- },
		{
			"NMAC427/guess-indent.nvim", -- newline indent
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				require("guess-indent").setup({})
			end,
		},
		{
			"lukas-reineke/indent-blankline.nvim", -- indent guides
			event = { "BufReadPre", "BufNewFile" },
			main = "ibl",
			opts = {},
		},
		{
			"folke/neoconf.nvim", --can import conf in .vscode
			event = "BufReadPre",
			cmd = "Neoconf",
		},
		{
			"mrjones2014/smart-splits.nvim", -- tmux integration somehow
			keys = {
				{ "<A-h>", mode = "n" },
				{ "<A-j>", mode = "n" },
				{ "<A-k>", mode = "n" },
				{ "<A-l>", mode = "n" },
			},
			config = function()
				require("smart-splits").setup({})
			end,
		},
		{
			"RRethy/vim-illuminate", -- highlight similar words
			event = { "BufReadPost", "BufNewFile" },
			config = function()
				require("illuminate").configure({})
			end,
		},
		-- {
		-- 	"CopilotC-Nvim/CopilotChat.nvim",
		-- 	dependencies = {
		-- 		{ "github/copilot.vim" },
		-- 		{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		-- 	},
		-- 	cmd = "CopilotChat",
		-- 	opts = {

		-- 		model = "claude-3.7-sonnet-thought", --  "gemini-2.5-pro" early stop
		-- 		auto_insert_mode = true, -- Enter insert mode when chat opens
		-- 		question_header = "  ",
		-- 		answer_header = " ",

		-- 		window = {
		-- 			layout = "float",
		-- 			relative = "editor",
		-- 			width = 0.5, -- 50% of editor width
		-- 			height = 0.9, -- 90% of editor height
		-- 			row = 0.05,
		-- 			col = 0.5, -- Position on the right side
		-- 			border = "rounded",
		-- 		},
		-- 		mappings = {
		-- 			close = {
		-- 				insert = "C-q", -- removes the default C-c mapping
		-- 			},
		-- 		},
		-- 		prompts = {
		-- 			-- Default prompts from your config...
		-- 			-- Explain = {
		-- 			-- 	prompt = "Write an explanation for the selected code as paragraphs of text.",
		-- 			-- 	system_prompt = "COPILOT_EXPLAIN",
		-- 			-- },
		-- 			-- Review = {
		-- 			-- 	prompt = "Review the selected code.",
		-- 			-- 	system_prompt = "COPILOT_REVIEW",
		-- 			-- },

		-- 			-- Other default prompts...
		-- 			Commit = {
		-- 				prompt = "Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.",
		-- 				context = "git:staged",
		-- 			},
		-- 		},
		-- 	},
		-- keys = {
		-- 	{
		-- 		"<leader>aa",
		-- 		function()
		-- 			return require("CopilotChat").toggle()
		-- 		end,
		-- 		desc = "Toggle",
		-- 		mode = { "n", "v" },
		-- 	},
		-- 	{
		-- 		"<leader>ax",
		-- 		function()
		-- 			return require("CopilotChat").reset()
		-- 		end,
		-- 		desc = "Clear",
		-- 		mode = { "n", "v" },
		-- 	},
		-- 	{
		-- 		"<leader>ac",
		-- 		":CopilotChatCommit<cr>",
		-- 		desc = "Commit",
		-- 		mode = { "n", "v" },
		-- 	},
		-- },
		-- -- See Commands section for default commands if you want to lazy load on them
		-- },

		-- Diagnostics / Trouble
		{
			"folke/trouble.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			cmd = "Trouble",
			opts = {},
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
		},
	},
	install = { colorscheme = { "gruvbox" } },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	-- automatically check for plugin updates
	-- checker = { enabled = true },
})

vim.cmd([[colorscheme gruvbox]])
-- Make the editor background transparent
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- For floating windows like LSP hover

-- Better highlight for selected buffer tab
vim.api.nvim_set_hl(0, "BufferCurrent", { bg = "#3c3836", bold = true })
vim.api.nvim_set_hl(0, "BufferCurrentMod", { bg = "#3c3836", bold = true })

vim.keymap.set(
	"n",
	"<leader>el",
	":Neotree filesystem toggle left<CR>",
	{ desc = "Explorer NeoTree (Files)", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>eb",
	":Neotree buffers toggle<CR>",
	{ desc = "Explorer NeoTree (Buffers)", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>eg",
	":Neotree git_status toggle<CR>",
	{ desc = "Explorer NeoTree (Git Status)", noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>ev", function()
	vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Edit Neovim config (init.lua)" })

-- vim.keymap.set("n", "<leader>sv", function() -- Not supported with lazy nvim, sorry

-- Buffer navigation shortcuts
vim.keymap.set("n", "]b", "<Cmd>BufferNext<CR>", { desc = "Next buffer", silent = true })
vim.keymap.set("n", "[b", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer", silent = true })

-- Tab navigation shortcuts
vim.keymap.set("n", "]t", "<Cmd>tabnext<CR>", { desc = "Next tab", silent = true })
vim.keymap.set("n", "[t", "<Cmd>tabprevious<CR>", { desc = "Previous tab", silent = true })

-- Quickfix navigation shortcuts
vim.keymap.set("n", "]q", "<Cmd>cnext<CR>", { desc = "Next quickfix item", silent = true })
vim.keymap.set("n", "[q", "<Cmd>cprevious<CR>", { desc = "Previous quickfix item", silent = true })

-- -- Barbar.nvim keymaps
-- vim.keymap.set('n', '<leader>bb', '<Cmd>BufferOrderByBufferNumber<CR>', { desc = 'Sort buffers by buffer number' })
-- vim.keymap.set('n', '<leader>bd', '<Cmd>BufferOrderByDirectory<CR>', { desc = 'Sort buffers by directory' })
-- vim.keymap.set('n', '<leader>bl', '<Cmd>BufferOrderByLanguage<CR>', { desc = 'Sort buffers by language' })
-- vim.keymap.set('n', '<leader>bw', '<Cmd>BufferOrderByWindowNumber<CR>', { desc = 'Sort buffers by window number' })

-- vim.keymap.set('n', '<leader>bc', '<Cmd>BufferClose<CR>', { desc = 'Close current buffer' })

-- -- Move buffer
-- vim.keymap.set('n', '<A-,>', '<Cmd>BufferMovePrevious<CR>', { desc = 'Move buffer to the left' })
-- vim.keymap.set('n', '<A-.>', '<Cmd>BufferMoveNext<CR>', { desc = 'Move buffer to the right' })

-- Keep search direction consistent (n forward, N backward)
vim.keymap.set(
	"n",
	"n",
	"v:searchforward ? 'n' : 'N'",
	{ expr = true, noremap = true, silent = true, desc = "Next search result (always forward)" }
)
vim.keymap.set(
	"n",
	"N",
	"v:searchforward ? 'N' : 'n'",
	{ expr = true, noremap = true, silent = true, desc = "Previous search result (always backward)" }
)

vim.api.nvim_create_user_command("Wipeout", function()
	vim.cmd("%bd|e#|bd# ")
end, {})

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	pattern = "*",
	nested = true,
	callback = function()
		-- Auto load session if started without arguments
		if vim.fn.argc() == 0 then
			require("persistence").load()
		end
	end,
})

-- Set colorcolumn for R files to indicate 80 character limit
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.r", "*.R", "*.Rmd", "*.rmd" },
	callback = function()
		vim.opt_local.colorcolumn = "80"
		vim.opt_local.textwidth = 80
	end,
})

-- `ctags -R --languages=python --kinds-python=cf .` only for classes and functions
local function lsp_or_tags_definition()
	local original_pos = vim.fn.getpos(".")
	-- Try to go to definition with LSP. pcall prevents errors if no LSP is attached.
	pcall(vim.lsp.buf.definition)

	-- After a short delay, check if the cursor has moved.
	vim.defer_fn(function()
		local new_pos = vim.fn.getpos(".")
		-- If the position is the same, it means LSP didn't find anything.
		if vim.deep_equal(original_pos, new_pos) then
			-- Fallback to ctags. 'tjump' is better than 'tag' as it shows a list for multiple matches.
			vim.cmd("tjump " .. vim.fn.expand("<cword>"))
		end
	end, 100) -- 100ms delay, can be adjusted
end

vim.api.nvim_create_user_command("DeletePrintLines", "g/\\.show()\\|print/d", {
	force = true,
	desc = "Delete all lines containing .show() or print",
})

vim.api.nvim_create_user_command("CurFilePath", function()
	local file_path = vim.fn.expand("%")
	vim.fn.setreg("+", file_path) -- Set the system clipboard register '+' to the file path
	print("Copied to clipboard: " .. file_path)
end, {
	force = true,
	desc = "Copy the full path of the current file to the clipboard",
})

local function pick_tmux_word()
	local words, seen = {}, {}
	for _, line in
		ipairs(vim.fn.systemlist([[tmux list-panes -s -F '#{pane_id}' | xargs -I {} tmux capture-pane -p -J -t {}]]))
	do
		for word in line:gmatch("%w+") do
			if not seen[word] then
				words[#words + 1], seen[word] = word, true
			end
		end
	end
	require("telescope.pickers")
		.new({}, {
			finder = require("telescope.finders").new_table({ results = words }),
			sorter = require("telescope.config").values.generic_sorter({}),
			attach_mappings = function(bufnr)
				require("telescope.actions").select_default:replace(function()
					local sel = require("telescope.actions.state").get_selected_entry()
					require("telescope.actions").close(bufnr)
					vim.api.nvim_put({ sel.value }, "c", false, true)
				end)
				return true
			end,
		})
		:find()
end

-- Create the keymap to trigger the function in Insert mode
vim.keymap.set("i", "<C-u>", pick_tmux_word, { desc = "Pick a word from tmux panes" })
vim.keymap.set("n", "<C-]>", lsp_or_tags_definition, { desc = "Go to definition (LSP > Tags)" })

-- Lazygit integration with Snacks
vim.keymap.set("n", "<leader>lg", function()
	Snacks.terminal("lazygit", { cwd = vim.fn.getcwd() })
end, { desc = "Open Lazygit" })

-- Find ctag for word under cursor in a new tab
vim.keymap.set("n", "<Leader>tf", function()
	vim.cmd("tabnew | tjump " .. vim.fn.expand("<cword>"))
end, { desc = "Find ctag for word under cursor" })

-- Native LSP completion setup
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

-- LSP completion keybindings
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { desc = "Trigger LSP completion" })

-- Auto-import on completion accept
vim.api.nvim_create_autocmd("CompleteDone", {
	callback = function()
		local completed_item = vim.v.completed_item
		if
			completed_item
			and completed_item.user_data
			and completed_item.user_data.nvim
			and completed_item.user_data.nvim.lsp
		then
			local completion_item = completed_item.user_data.nvim.lsp.completion_item
			if completion_item and completion_item.additionalTextEdits then
				vim.schedule(function()
					vim.lsp.util.apply_text_edits(
						completion_item.additionalTextEdits,
						vim.api.nvim_get_current_buf(),
						"utf-8"
					)
				end)
			end
		end
	end,
})

-- TODO:
--  gr currently shows imports statement. Don't  [apparently this is very hard]
--  gr should also be ctrl - ] when there's nothing else
-- dir-telescope.nvim
-- space ev should not switch neotree to file if there's a neotree pane already open (buffers / git changes) instead should close it.
