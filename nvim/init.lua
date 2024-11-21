-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

-- Avoid showing extra messages when using completion
vim.opt.shortmess:append("c")

-- Keep my lines 100 chars at most
vim.opt.cc = { textwidth = 80 }

require("config")

require("plugins")
-- let g:svelte_preprocessors = ['typescript']

vim.g.tundra_biome = "jungle"

vim.g.barbar_auto_setup = false

local lspconfig = require("lspconfig")
local cmp = require("cmp")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local theme = require("lualine.themes.iceberg_dark")
theme.normal.c.bg = nil
-- theme.insert.c.bg = nil
-- theme.visual.c.bg = nil
-- theme.replace.c.bg = nil
-- theme.command.c.bg = nil
theme.inactive.c.bg = nil

require("lualine").setup({
	options = {
		theme = theme,
		section_separators = { left = " ", right = " " },
		component_separators = { left = "  ", right = "  " },
	},
	sections = {
		lualine_c = { "filename", "LspStatus" },
	},
})

require("transparent").setup({})

require("catppuccin").setup({
	transparent_background = true, -- disables setting the background color.
	default_integrations = true,
	integrations = {
		cmp = true,
		nvimtree = true,
	},
})

require("devicon-colorscheme").setup({})

require("nvim-tree").setup({})

require("colorizer").setup({
	"*",
}, {
	RGB = true, -- #RGB hex codes
	RRGGBB = true, -- #RRGGBB hex codes
	names = true, -- 'Name' codes like Blue
	RRGGBBAA = true, -- #RRGGBBAA hex codes
	rgb_fn = true, -- CSS rgb() and rgba() functions
	hsl_fn = true, -- CSS hsl() and hsla() functions
	css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
	css_fn = true,
})

lspconfig.taplo.setup({})

lspconfig.nil_ls.setup({
	capabilities = capabilities,
	settings = {
		["nil"] = {
			formatting = {
				command = { "alejandra" },
			},
		},
	},
})

lspconfig.svelte.setup({
	-- Add filetypes for the server to run and share info between files
	filetypes = { "typescript", "javascript", "svelte", "html", "css" },
})

-- Capabilities required for the visualstudio lsps (css, html, etc)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Activate LSPs
-- All LSPs in this list need to be manually installed via NPM/PNPM/whatevs
local servers = { "tailwindcss", "ts_ls", "jsonls", "eslint" }
for _, lsp in pairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilites = capabilities,
	})
end

-- This is an interesting one, for some reason these two LSPs (CSS/HTML) need to
-- be activated separately outside of the above loop. If someone can tell me why,
-- send me a note...
lspconfig.cssls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.html.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	-- window = {
	--     completion = cmp.config.window.bordered(),
	--     documentation = cmp.config.window.bordered(),
	-- },
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			local luasnip = require("luasnip")

			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.locally_jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "buffer" },
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip", option = { show_autosnippets = true } },
	}),
})

cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" },
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>d", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>s", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>t", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
		vim.keymap.set("n", "<leader>e", function(args)
			vim.diagnostic.open_float(nil, { focusable = false })
		end, opts)
	end,
})

vim.g.rustaceanvim = {
	tools = {
		reload_workspace_from_cargo_toml = true,
		inlay_hints = {
			auto = true,
			only_current_line = false,
			show_parameter_hints = true,
			parameter_hints_prefix = "<- ",
			other_hints_prefix = "=> ",
			max_len_align = false,
			max_len_align_padding = 1,
			right_align = false,
			right_align_padding = 7,
			highlight = "Comment",
		},
	},
	server = {
		standalone = true,
		settings = {
			["rust-analyzer"] = {
				cargo = {
					-- features = {'__ci'},
					runBuildScripts = true,
				},
				checkOnSave = {
					-- enable = 'true'
					command = "clippy",
				},
				imports = {
					granularity = {
						enable = "true",
						group = "crate",
					},
				},
				procMacro = {
					enable = true,
				},
				diagnostics = {
					experimental = {
						enable = true,
					},
				},
			},
		},
		autostart = true,
		capabilities = capabilities,
	},
}

-- Keymaps for Luasnip
local ls = require("luasnip")
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set("i", "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

vim.keymap.set("i", "jj", "<Esc>`^")

vim.keymap.set("n", "<Space>", "<cmd>:noh<cr>")
vim.keymap.set("n", "<C-n>", "<cmd>:NvimTreeToggle<cr>")

vim.keymap.set("n", "<Leader>n", "<cmd>:tabnew<cr>")
vim.keymap.set("n", "<Leader>j", "<cmd>:tabprev<cr>")
vim.keymap.set("n", "<Leader>k", "<cmd>:tabnext<cr>")

require("nvim-lightbulb").setup({
	sign = {
		enabled = true,
		text = "⮓ ",
		hl = "LightBulbSign",
	},
	autocmd = {
		-- Whether or not to enable autocmd creation.
		enabled = true,
		-- See |updatetime|.
		-- Set to a negative value to avoid setting the updatetime.
		updatetime = 200,
		-- See |nvim_create_autocmd|.
		events = { "CursorHold", "CursorHoldI" },
		-- See |nvim_create_autocmd| and |autocmd-pattern|.
		pattern = { "*" },
	},
	hide_in_unfocused_buffer = false,
})

local theme = {
	fill = "TabLineFill",
	-- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
	head = "TabLine",
	current_tab = "TabLineSel",
	tab = "TabLine",
	win = "TabLine",
	tail = "TabLine",
}

require("tabby.tabline").set(function(line)
	return {
		{
			{ "  ", hl = theme.head },
			line.sep("", theme.head, theme.fill), -- 
		},
		line.tabs().foreach(function(tab)
			local hl = tab.is_current() and theme.current_tab or theme.tab
			return {
				line.sep("", hl, theme.fill), -- 
				tab.is_current() and "󰇀" or "󰻋",
				tab.number(),
				tab.name(),
				-- tab.close_btn(''), -- show a close button
				line.sep("", hl, theme.fill), -- 
				hl = hl,
				margin = " ",
			}
		end),

		line.spacer(),
		-- shows list of windows in tab
		line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
			return {
				line.sep("", theme.win, theme.fill),
				win.is_current() and "" or "",
				win.buf_name(),
				line.sep("", theme.win, theme.fill),
				hl = theme.win,
				margin = " ",
			}
		end),
		{
			line.sep("", theme.tail, theme.fill), -- 
			{ " 󱔼 ", hl = theme.tail },
		},
		hl = theme.fill,
	}
end)

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*",
-- 	callback = function(args)
-- 		require("conform").format({ bufnr = args.buf })
-- 	end,
-- })

vim.cmd("colorscheme tundra")
