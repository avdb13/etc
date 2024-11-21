require("lazy").setup({
	-- ∨ LSP
	"neovim/nvim-lspconfig",
	-- ∧ LSP

	-- ∨ diagnostics
	"folke/trouble.nvim",
	"kosayoda/nvim-lightbulb",
	-- ∧ diagnostics

	-- ∨ highlighting
	"nvim-treesitter/nvim-treesitter",
	-- ∧ highlighting

	-- ∨ snippets
	"l3mon4d3/luasnip",
	-- ∧ snippets

	-- ∨ formatting
	"stevearc/conform.nvim",
	-- ∧ formatting

	-- ∨ autocompletion
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",

	"saadparwaiz1/cmp_luasnip",
	"onsails/lspkind.nvim",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	-- ∧ autocompletion

	-- ∨ git integration
	"sindrets/diffview.nvim",
	"neogitorg/neogit",
	"lewis6991/gitsigns.nvim",
	"tpope/vim-fugitive",
	-- ∧ git integration

	-- ∨ telescope
	"nvim-telescope/telescope.nvim",
	"nvim-telescope/telescope-fzy-native.nvim",
	"nvim-telescope/telescope-smart-history.nvim",
	-- ∧ telescope

	-- ∨ UI
	"nvim-tree/nvim-tree.lua",

	"luukvbaal/statuscol.nvim",

	"nvim-lualine/lualine.nvim",

	{
		"j-hui/fidget.nvim",
		tag = "v1.4.5",
		config = function()
			require("fidget").setup({})
		end,
	},
	"SmiteshP/nvim-navic",

	"nanozuki/tabby.nvim",

	"nvim-treesitter/nvim-treesitter-context",

	"dgox16/devicon-colorscheme.nvim",
	"norcalli/nvim-colorizer.lua",
	"yggdroot/indentline",
	"xiyaowong/transparent.nvim",
	-- ∧ UI

	-- ∨ language support
	"mrcjkb/rustaceanvim",
	{
		"saecki/crates.nvim",
		tag = "stable",
		config = function()
			require("crates").setup()
		end,
	},

	"othree/html5.vim",
	"pangloss/vim-javascript",
	"evanleck/vim-svelte",
	{
		"prettier/vim-prettier",
		run = "npm install",
		ft = { "javascript", "typescript", "css", "scss", "json", "graphql", "markdown", "vue", "yaml", "html" },
	},

	-- ∧ language support

	-- ∨ navigation/editing enhancement
	{
		"jinh0/eyeliner.nvim",
		config = function()
			require("eyeliner").setup({
				highlight_on_key = true,
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	"tpope/vim-commentary",
	-- ∧ navigation/editing enhancement

	-- ∨ UX
	"wakatime/vim-wakatime",
	-- ∧ UX

	-- ∨ miscellaneous
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",
	-- ∧ miscellaneous

	-- ∨ colorschemes
	"folke/tokyonight.nvim",
	"rose-pine/neovim",
	"catppuccin/nvim",
	"nordtheme/vim",

	"sam4llis/nvim-tundra",
	"Domeee/mosel.nvim",

	"Yazeed1s/minimal.nvim",
	"yazeed1s/oh-lucy.nvim",
	"miikanissi/modus-themes.nvim",
	"andreypopp/vim-colors-plain",
	"datsfilipe/vesper.nvim",
	"numToStr/sakura.nvim",
	"olivercederborg/poimandres.nvim",
	"AlexvZyl/nordic.nvim",
	-- ∧ colorschemes

	{
		"folke/trouble.nvim",
		opts = {
			modes = {
				cascade = {
					mode = "diagnostics", -- inherit from diagnostics mode
					filter = function(items)
						local severity = vim.diagnostic.severity.HINT
						for _, item in ipairs(items) do
							severity = math.min(severity, item.severity)
						end
						return vim.tbl_filter(function(item)
							return item.severity == severity
						end, items)
					end,
				},
			},
		},
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
})
