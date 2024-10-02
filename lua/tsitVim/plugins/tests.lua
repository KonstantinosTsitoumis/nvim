return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
	},
	config = function()
		local neotest = require("neotest")

		neotest.setup({
			adapters = {
				require("neotest-python")({
					dap = { justMyCode = false }, -- Configure for debugging test code
				}),
			},
		})

		vim.keymap.set("n", "<leader>ttn", function()
			neotest.run.run()
		end, { desc = "Run nearest test" })
		vim.keymap.set("n", "<leader>ttf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Run test file" })
		vim.keymap.set("n", "<leader>tts", function()
			neotest.run.stop()
		end, { desc = "Stop test" })
		vim.keymap.set("n", "<leader>tto", function()
			neotest.output.open({ enter = true })
		end, { desc = "Open test output" })
		vim.keymap.set("n", "<leader>ttsu", function()
			neotest.summary.toggle()
		end, { desc = "Toggle test summary" })
	end,
}
