return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	opts = function()
		return require("configs.telescope")
	end,

	config = function(_, opts) 
		require("telescope").setup(opts)
		require("telescope").load_extension("ui-select")
	end,
}
