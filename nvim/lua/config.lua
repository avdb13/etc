local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g

opt.encoding = "utf-8"

opt.expandtab = true
opt.number = true
opt.equalalways = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.laststatus = 2
opt.showtabline = 2

opt.foldenable = true
opt.foldmethod = "indent"
opt.foldnestmax = 10
opt.foldlevel = 2

opt.wildignore = opt.wildignore
	.. table.concat({
		"blue.vim",
		"darkblue.vim",
		"delek.vim",
		"desert.vim",
		"elflord.vim",
		"evening.vim",
		"industry.vim",
		"koehler.vim",
		"lunaperche.vim",
		"morning.vim",
		"murphy.vim",
		"pablo.vim",
		"peachpuff.vim",
		"quiet.vim",
		"retrobox.vim",
		"ron.vim",
		"shine.vim",
		"slate.vim",
		"sorbet.vim",
		"torte.vim",
		"wildcharm.vim",
		"zaibatsu.vim",
		"zellner.vim",
	}, ",")

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Search down into subfolders
-- opt.path = vim.o.path .. "**"

-- opt.relativenumber = true
-- opt.cursorline = true
-- opt.lazyredraw = true
-- opt.showmatch = true -- Highlight matching parentheses, etc
-- opt.incsearch = true
-- opt.hlsearch = true

opt.spell = true
opt.spelllang = "en"

-- opt.history = 2000
opt.nrformats = "bin,hex" -- 'octal'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
-- opt.cmdheight = 0

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.javascript_plugin_jsdoc = 1
g.mapleader = ","

cmd("syntax on")

-- opt.colorcolumn = '100'

-- -- Native plugins
-- cmd.filetype('plugin', 'indent', 'on')
-- cmd.packadd('cfilter') -- Allows filtering the quickfix list with :cfdo
