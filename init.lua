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
		{ "Mofiqul/dracula.nvim", name = "dracula", priority = 1000 },
		{ "tomasr/molokai", name = "molokai", priority = 1000 },
		{ "ellisonleao/gruvbox.nvim", name = "gruvbox", priority = 1000 },
		{
			"powerman/vim-plugin-AnsiEsc", -- helps with ^[ type of console outputs in file
			cmd = "AnsiEsc",
		},
		{ "akinsho/git-conflict.nvim", version = "*", config = true },
		-- LSP / Mason / DAP
		{
			"williamboman/mason.nvim",
			cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
			config = function()
				require("mason").setup()
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "williamboman/mason.nvim" },
			tag = "v2.0.0-rc.1",
			opts = {
				ensure_installed = {
					"pyright",
					-- "pylint",
					"r_language_server",
					"yamlls",
					"azure_pipelines_ls",
					"jsonls",
					"lua_ls",
					"ruff", -- Add ruff to ensure it's installed by Mason
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
			opts = {
				formatters_by_ft = {
					python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
					r = { "styler" },
					lua = { "stylua" },
				},
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

		-- { 'andymass/vim-split-diff', lazy = true, cmd = 'Splitdiff' },
		--
		{
			"lvimuser/lsp-inlayhints.nvim",
			dependencies = { "neovim/nvim-lspconfig" },
			config = function()
				require("lsp-inlayhints").setup()
			end,
		},
		{ "sindrets/diffview.nvim" },
		{
			-- LSP Configuration
			"neovim/nvim-lspconfig",
			dependencies = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
			},
			config = function()
				local lspconfig = require("lspconfig")
				local capabilities = require("cmp_nvim_lsp").default_capabilities()

				-- Define a common on_attach function for LSP keybindings
				local on_attach = function(client, bufnr)
					local bufopts = { noremap = true, silent = true, buffer = bufnr }
					-- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('keep', bufopts, { desc = 'LSP Go to Declaration' }))
					vim.keymap.set(
						"n",
						"gd",
						vim.lsp.buf.definition,
						vim.tbl_extend("keep", bufopts, { desc = "LSP Go to Definition" })
					) -- Uncommented gd
					vim.keymap.set(
						"n",
						"K",
						vim.lsp.buf.hover,
						vim.tbl_extend("keep", bufopts, { desc = "LSP Hover Documentation" })
					)
					-- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('keep', bufopts, { desc = 'LSP Go to Implementation' }))
					vim.keymap.set(
						"n",
						"<leader>D",
						vim.lsp.buf.type_definition,
						vim.tbl_extend("keep", bufopts, { desc = "LSP Go to Type Definition" })
					)
					vim.keymap.set(
						"n",
						"<leader>rn",
						vim.lsp.buf.rename,
						vim.tbl_extend("keep", bufopts, { desc = "LSP Rename Symbol" })
					)
					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						vim.tbl_extend("keep", bufopts, { desc = "LSP Code Action" })
					)
					vim.keymap.set(
						"n",
						"gr",
						vim.lsp.buf.references,
						vim.tbl_extend("keep", bufopts, { desc = "LSP Go to References" })
					)
					if client.server_capabilities.completionProvider then
						bufopts.desc = "Trigger completion"
						vim.keymap.set("i", "<C-Space>", vim.lsp.buf.completion, bufopts) -- don't work cuz tmux pane switch
					end
				end

				-- Autocommand to attach inlay hints
				vim.api.nvim_create_augroup("LspAttach_inlayhints", { clear = true })
				vim.api.nvim_create_autocmd("LspAttach", {
					group = "LspAttach_inlayhints",
					callback = function(args)
						if not (args.data and args.data.client_id) then
							return
						end
						local bufnr = args.buf
						local client = vim.lsp.get_client_by_id(args.data.client_id)
						local inlayhints_plugin = require("lazy.core.config").plugins["lsp-inlayhints.nvim"]
						if
							client
							and client.supports_method("textDocument/inlayHint")
							and inlayhints_plugin
							and inlayhints_plugin.loaded
						then
							pcall(require("lsp-inlayhints").on_attach, client, bufnr)
						end
					end,
				})

				-- Autocommand to disable hover for ruff if pyright is also active
				vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true })
				vim.api.nvim_create_autocmd("LspAttach", {
					group = "lsp_attach_disable_ruff_hover",
					callback = function(args)
						local client = vim.lsp.get_client_by_id(args.data.client_id)
						if client and client.name == "ruff" then
							client.server_capabilities.hoverProvider = false
						end
					end,
					desc = "LSP: Disable hover capability from Ruff",
				})

				lspconfig.pyright.setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						pyright = {
							disableOrganizeImports = true,
						},
						python = {
							analysis = {
								-- Ignore all files for analysis to exclusively use Ruff for linting
								-- ignore = { '*' },
							},
						},
					},
				})
				lspconfig.jsonls.setup({
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

				lspconfig.azure_pipelines_ls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})

				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = {
						Lua = {
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
				-- linting disable
				-- lspconfig.ruff.setup({
				--   capabilities = capabilities,
				--   on_attach = on_attach,
				-- })
			end,
		},

		{
			"antosha417/nvim-lsp-file-operations",
			dependencies = { "nvim-lua/plenary.nvim", "nvim-neo-tree/neo-tree.nvim" },
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
					ensure_installed = { "python", "lua", "vim", "r", "bash", "yaml", "markdown" },
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
		{ "tpope/vim-surround", event = "VeryLazy" },
		{ "tpope/vim-commentary", event = "VeryLazy" },
		{ "romainl/vim-cool", event = "VeryLazy" }, -- Automatically clear search highlight on cursor move
		{ "tpope/vim-fugitive", event = "VeryLazy", cmd = "Git" },
		{ "mhinz/vim-signify" },
		{ "jalvesaq/Nvim-R", ft = { "r", "rmd", "quarto" } },
		{ "idbrii/vim-mergetool", cmd = "Mergetool" },
		{
			"f-person/git-blame.nvim",
			event = "BufReadPre",
			config = function()
				require("gitblame").setup({ enabled = true })
			end,
		},

		-- Completion Engine (nvim-cmp)
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
			config = function()
				local cmp = require("cmp")
				cmp.setup({
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "buffer" },
						{ name = "path" },
					}),
					mapping = cmp.mapping.preset.insert({
						["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
					}), -- To make pyright auto import work
				})
			end,
		},
		-- File Explorer
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
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
		},
		
		-- lazy.nvim
		{
			"folke/noice.nvim",
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
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			dependencies = {
				{ "github/copilot.vim" },
				{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
			},
			cmd = "CopilotChat",
			opts = {

				model = "claude-3.7-sonnet-thought", --  "gemini-2.5-pro" early stop
				auto_insert_mode = true, -- Enter insert mode when chat opens
				question_header = "  ",
				answer_header = " ",

				window = {
					layout = "float",
					relative = "editor",
					width = 0.5, -- 50% of editor width
					height = 0.9, -- 90% of editor height
					row = 0.05,
					col = 0.5, -- Position on the right side
					border = "rounded",
				},
				mappings = {
					close = {
						insert = "C-q", -- removes the default C-c mapping
					},
				},
				prompts = {
					-- Default prompts from your config...
					-- Explain = {
					-- 	prompt = "Write an explanation for the selected code as paragraphs of text.",
					-- 	system_prompt = "COPILOT_EXPLAIN",
					-- },
					-- Review = {
					-- 	prompt = "Review the selected code.",
					-- 	system_prompt = "COPILOT_REVIEW",
					-- },

					-- Other default prompts...
					Commit = {
						prompt = "Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.",
						context = "git:staged",
					},
				},
			},
			keys = {
				{
					"<leader>aa",
					function()
						return require("CopilotChat").toggle()
					end,
					desc = "Toggle",
					mode = { "n", "v" },
				},
				{
					"<leader>ax",
					function()
						return require("CopilotChat").reset()
					end,
					desc = "Clear",
					mode = { "n", "v" },
				},
				{
					"<leader>ac",
					":CopilotChatCommit<cr>",
					desc = "Commit",
					mode = { "n", "v" },
				},
			},
			-- See Commands section for default commands if you want to lazy load on them
		},

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
	-- automatically check for plugin updates
	-- checker = { enabled = true },
})

vim.cmd([[colorscheme gruvbox]])
-- Make the editor background transparent
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- For floating windows like LSP hover

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

-- Buffer navigation shortcuts
vim.keymap.set("n", "]b", ":bnext<CR>", { desc = "Next buffer", silent = true })
vim.keymap.set("n", "[b", ":bprevious<CR>", { desc = "Previous buffer", silent = true })

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

-- function to find and insert words from all tmux panes.
local function pick_tmux_word()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local actions = require("telescope.actions")
	local conf = require("telescope.config").values

	local cmd = [[tmux list-panes -s -F '#{pane_id}' | xargs -I {} tmux capture-pane -p -J -t {}]]

	-- Asynchronously run the command to avoid freezing Neovim
	vim.loop
		.spawn("sh", {
			args = { "-c", cmd },
		}, function(code)
			if code ~= 0 then
				vim.notify("Error getting tmux pane content, tmux command failed.", vim.log.levels.ERROR)
			end
		end)
		:on_stdout(function(err, data)
			assert(not err, err)
			if not data then
				return
			end

			-- Process the output into a unique list of words
			local words = {}
			local unique_words = {}
			for word in data:gmatch("%w+") do
				if not unique_words[word] then
					table.insert(words, word)
					unique_words[word] = true
				end
			end

			if #words == 0 then
				vim.notify("No words found in tmux panes.", vim.log.levels.INFO)
				return
			end

			-- Create and launch the Telescope picker
			pickers
				.new({}, {
					prompt_title = "Words From Tmux Panes",
					finder = finders.new_table({ results = words }),
					sorter = conf.generic_sorter({}),
					attach_mappings = function(prompt_bufnr)
						actions.select_default:replace(function()
							local selection = actions.get_selected_entry()
							actions.close(prompt_bufnr)
							if selection then
								vim.api.nvim_put({ selection.value }, "c", false, true)
							end
						end)
						return true
					end,
				})
				:find()
		end)
end

-- Create the keymap to trigger the function in Insert mode
vim.keymap.set("i", "<C-u>", pick_tmux_word, { desc = "Pick a word from tmux panes" })
vim.keymap.set("n", "<C-]>", lsp_or_tags_definition, { desc = "Go to definition (LSP > Tags)" })


-- Find ctag for word under cursor in a new tab
vim.keymap.set("n", "<Leader>tf", function()
  vim.cmd("tabnew | tjump " .. vim.fn.expand("<cword>"))
end, { desc = "Find ctag for word under cursor" })

-- TODO:
--  File rename  with lsp
--  gr currently shows imports statement. Don't  [apparently this is very hard]
--  gr should be ctrl - ] also when there's nothing else
--  `ysaw` combination does not repeat with .
--	Tabs should be able to be reordered. (DONE)
--  why md files are folded auto.? open folds by default
