return {
	"ruifm/gitlinker.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("gitlinker").setup({
			mappings = "<leader>yg",
		})
	end,
}
