local opt = vim.opt
local g = vim.g
local o = vim.o

opt.ignorecase = true
opt.smartcase = true
opt.showmatch = true
opt.hlsearch = true
opt.incsearch = true

opt.nu = true
opt.relativenumber = true

o.cursorline = true
o.cursorlineopt = "number"

o.splitbelow = true
o.splitright = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.termguicolors = true

opt.scrolloff = 4
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 250

opt.colorcolumn = "80"

opt.cmdheight = 0
vim.cmd [[ autocmd RecordingEnter * set cmdheight=1 ]]
vim.cmd [[ autocmd RecordingLeave * set cmdheight=0 ]]

o.clipboard = "unnamedplus"

o.foldmethod = "syntax"
o.foldenable = false
