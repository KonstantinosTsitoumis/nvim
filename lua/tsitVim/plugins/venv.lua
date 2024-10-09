return {
	"linux-cultist/venv-selector.nvim",
	dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
	config = function()
		venv_selector = require("venv-selector")

		venv_selector.setup({
			-- Your options go here
			name = ".venv",
			stay_on_this_version = true,
			-- auto_refresh = false
		})

		local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")

		if venv ~= "" then
			venv_selector.retrieve_from_cache()
		end
	end,
	event = "VeryLazy",
}
