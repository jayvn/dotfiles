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
vim.opt.undofile = true

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
		-- 'folke/tokyonight.nvim', "tomasr/molokai", "ellisonleao/gruvbox.nvim",
		{ "ellisonleao/gruvbox.nvim", name = "gruvbox", priority = 1000, lazy = false },
		{
			"powerman/vim-plugin-AnsiEsc", -- helps with ^[ type of console outputs in file
			cmd = "AnsiEsc",
		},
		{ "akinsho/git-conflict.nvim", version = "*", event = "BufReadPre", config = true },
		{
			"folke/snacks.nvim",
			lazy = false,
			priority = 1000, -- load early so Snacks.* is available everywhere
			opts = {
				terminal = { enabled = true }, -- used for lazygit
				notifier = { enabled = true }, -- replaces noice/nvim-notify
				input = { enabled = true }, -- replaces vim.ui.input (was handled by noice/nui)
				statuscolumn = { enabled = true }, -- nicer sign/fold/number columns
				words = { enabled = true }, -- highlight word under cursor (like LSP document highlight)
			},
		},
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
					-- "pylint",
					-- "r_language_server",
					"yamlls",
					"azure_pipelines_ls",
					"jsonls",
					"lua_ls",
					"rust_analyzer", -- Rust LSP Server
					-- "bashls", -- installed externally
					-- "basedpyright", -- installed globally
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
					-- r = { "styler" },
					lua = { "stylua" },
					bash = { "shfmt" },
					sh = { "shfmt" },
					zsh = { "shfmt" },
					rust = { "rustfmt" },
				},
				-- formatters = {
				-- 	styler = {
				-- 		inherit = false,
				-- 		command = "R",
				-- 		args = {
				-- 			"-s",
				-- 			"-e",
				-- 			"styler::style_file(commandArgs(TRUE), style = styler::tidyverse_style, scope = I(c('indention', 'spaces', 'tokens')), indent_by = 2)",
				-- 			"--args",
				-- 			"$FILENAME",
				-- 		},
				-- 		stdin = false,
				-- 	},
				-- },
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
				local capabilities =
					require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
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

					vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
				end

				vim.lsp.config("basedpyright", {
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
				vim.lsp.enable("basedpyright")

				vim.lsp.config("jsonls", {
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
				vim.lsp.enable("jsonls")

				-- vim.lsp.config("r_language_server", {
				-- 	capabilities = capabilities,
				-- 	on_attach = on_attach,
				-- 	settings = {
				-- 		r = {
				-- 			lsp = {
				-- 				debug = false,
				-- 				log_level = "error",
				-- 				rich_documentation = true,
				-- 			},
				-- 			rpath = {
				-- 				vim.fn.expand("$PWD/packages"),
				-- 			},
				-- 			source = {
				-- 				global_source = vim.fn.expand("$PWD/globals.R"),
				-- 			},
				-- 		},
				-- 	},
				-- })
				-- vim.lsp.enable("r_language_server")

				vim.lsp.config("azure_pipelines_ls", {
					capabilities = capabilities,
					on_attach = on_attach,
				})
				vim.lsp.enable("azure_pipelines_ls")

				vim.lsp.config("lua_ls", {
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
				vim.lsp.enable("lua_ls")

				vim.lsp.config("rust_analyzer", {
					capabilities = capabilities,
					on_attach = on_attach,
				})
				vim.lsp.enable("rust_analyzer")

				vim.lsp.config("bashls", {
					capabilities = capabilities,
					on_attach = on_attach,
				})
				vim.lsp.enable("bashls")
				-- tried ruff , doesn't have all features as basedpyright which also has file rename
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
					ensure_installed = { "python", "lua", "vim", --[["r",]] "bash", "yaml", "markdown", "rust", --[["rnoweb"]] },
					highlight = {
						enable = true,
						-- markdown parser occasionally crashes with invalid range; fall back to vim regex
						disable = function(lang, _)
							if lang == "markdown" then
								return true
							end
						end,
						additional_vim_regex_highlighting = { "markdown" },
					},
					indent = { enable = true },
				})
			end,
		},
		-- Completion
		{
			"saghen/blink.cmp",
			lazy = false,
			dependencies = "rafamadriz/friendly-snippets",
			version = "v0.*",
			opts = {
				keymap = {
					preset = "default",
					["<Tab>"] = {},
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				completion = {
					accept = {
						auto_brackets = { enabled = true },
						resolve_timeout_ms = 500,
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
					},
				},
				signature = { enabled = true },
			},
			opts_extend = { "sources.default" },
		},

		-- Utils / Tools
		{ "godlygeek/tabular", cmd = { "Tabularize", "Tab" } },
		{
			"kylechui/nvim-surround",
			version = "*",
			event = "VeryLazy",
			config = true,
		},

		{ "romainl/vim-cool", event = "VeryLazy" }, -- Automatically clear search highlight on cursor move
		{ "tpope/vim-fugitive", event = "VeryLazy", cmd = "Git" },
		{ "mhinz/vim-signify" },
		-- { "R-nvim/R.nvim", ft = { "r", "rmd", "quarto" }, lazy = false },
		-- { "idbrii/vim-mergetool", cmd = "Mergetool" },
		{
			"f-person/git-blame.nvim",
			event = "BufReadPre",
			config = true,
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
			lazy = false,
			config = true,
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
			dependencies = { "nvim-lua/plenary.nvim" },
			cmd = { "Telescope" },
			keys = {
				{ "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Telescope find files" },
				{ "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Telescope live grep" },
				{ "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Telescope buffers" },
				{ "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Telescope recent files (MRU)" },
				{ "<leader>ft", function() require("telescope.builtin").tags() end, desc = "Telescope tags" },
				{ "<leader>fsd", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Telescope LSP document symbols" },
				{ "<leader>fc", function() require("telescope.builtin").commands() end, desc = "Telescope commands" },
			},
		},
		{ "folke/which-key.nvim", event = "VeryLazy" },

		{
			"nvim-treesitter/nvim-treesitter-context",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			event = { "BufReadPost", "BufNewFile" },
		},



		{
			"mfussenegger/nvim-lint",
			event = { "BufWritePost", "BufReadPost" },
			config = function()
				require("lint").linters_by_ft = {
					python = { "pylint" }, -- 'ruff' is not good enough?
					-- r = { "lintr" },
					lua = { "luacheck" },
				}
			end,
		},

		{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {}, event = "VeryLazy" }, -- TODO/WARN highlight
		{
			"NMAC427/guess-indent.nvim", -- newline indent
			event = { "BufReadPre", "BufNewFile" },
			config = true,
		},
		{
			"lukas-reineke/indent-blankline.nvim", -- indent guides
			event = { "BufReadPre", "BufNewFile" },
			main = "ibl",
			config = true,
		},
		{
			"folke/neoconf.nvim", --can import conf in .vscode/
			event = "BufReadPre",
			cmd = "Neoconf",
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
			-- Re-attach treesitter to all buffers restored by the session,
			-- since BufReadPost fired before treesitter was loaded.
			vim.schedule(function()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(buf) then
						local ok, parser = pcall(vim.treesitter.get_parser, buf)
						if ok and parser then
							vim.treesitter.start(buf)
						end
					end
				end
			end)
		end
	end,
})

-- Set colorcolumn for R files to indicate 80 character limit
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
-- 	pattern = { "*.r", "*.R", "*.Rmd", "*.rmd" },
-- 	callback = function()
-- 		vim.opt_local.colorcolumn = "80"
-- 		vim.opt_local.textwidth = 80
-- 	end,
-- })

-- `ctags -R --languages=python --kinds-python=cf .` only for classes and functions
local function lsp_or_tags_definition()
	vim.lsp.buf.definition({
		on_list = function(opts)
			if opts.items and #opts.items > 0 then
				vim.fn.setqflist({}, " ", opts)
				vim.cmd("cfirst")
			else
				vim.cmd("tjump " .. vim.fn.expand("<cword>"))
			end
		end,
	})
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

-- Completion options for blink.cmp
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- TODO:
--  gr currently shows imports statement. Don't  [apparently this is very hard]
--  gr should also be ctrl - ] when there's nothing else
-- dir-telescope.nvim
-- space ev should not switch neotree to file if there's a neotree pane already open (buffers / git changes) instead should close it.
-- organize this file by logical sections
