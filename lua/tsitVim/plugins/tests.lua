return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/neotest-python", -- Python adapter for Neotest
		"mfussenegger/nvim-dap", -- DAP core
		"mfussenegger/nvim-dap-python", -- DAP Python support
		"rcarriga/nvim-dap-ui", -- DAP UI
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		-- Neotest configuration with DAP
		neotest = require("neotest")

		neotest.setup({
			summary = {
				follow = true,
			},
			icons = {
				expanded = "",
				child_prefix = "",
				child_indent = "",
				final_child_prefix = "",
				non_collapsible = "",
				collapsed = "",

				passed = "",
				running = "",
				failed = "",
				unknown = "",
			},
			adapters = {
				require("neotest-python")({
					dap = {
						justMyCode = false, -- Debug into library code
						console = "integratedTerminal", -- Output console setting
					},
					args = { "--log-level", "DEBUG", "-vv" }, -- Pytest arguments
					runner = "pytest", -- Set the test runner
				}),
			},
		})

		-- Setup DAP for Python
		require("dap-python").setup(
			vim.fn.glob(vim.fn.stdpath("data") .. "/mason/") .. "packages/debugpy/venv/bin/python"
		)

		-- Keybindings for running tests with Neotest
		vim.keymap.set("n", "<leader>ttn", function()
			neotest.run.run() -- Run nearest test
		end, { desc = "Run nearest test" })

		vim.keymap.set("n", "<leader>ttf", function()
			neotest.run.run(vim.fn.expand("%")) -- Run test file
			neotest.summary.toggle()
		end, { desc = "Run test file" })

		vim.keymap.set("n", "<leader>tts", function()
			neotest.run.stop() -- Stop test
		end, { desc = "Stop test" })

		vim.keymap.set("n", "<leader>tto", function()
			neotest.output.open({ enter = true }) -- Open test output
		end, { desc = "Open test output" })

		vim.keymap.set("n", "<leader>ttu", function()
			neotest.summary.toggle() -- Toggle test summary
		end, { desc = "Toggle test summary" })

		vim.keymap.set("n", "<leader>ttd", function()
			neotest.run.run({ strategy = "dap" }) -- Test Method with DAP
		end, { desc = "Run nearest test method with DAP" })

		vim.keymap.set("n", "<leader>ttDF", function()
			neotest.run.run({ vim.fn.expand("%"), strategy = "dap" }) -- Test Class with DAP
		end, { desc = "Run all tests in file with DAP" })

		-- DAP keybindings
		local dap = require("dap")

		-- Define custom highlight groups
		vim.cmd("highlight DapBreakpointText guifg=#FF0000 gui=bold") -- Red bold text for breakpoint
		vim.cmd("highlight DapStoppedText guifg=#00FF00 gui=bold") -- Green bold text for stopped sign
		vim.cmd("highlight DapBreakpointLine guibg=#330000") -- Dark red background for breakpoint line
		vim.cmd("highlight DapStoppedLine guibg=#003300") -- Dark green background for stopped line
		vim.cmd("highlight DapBreakpointNum guifg=#FF0000 gui=bold") -- Red bold text for line number at breakpoint
		vim.cmd("highlight DapStoppedNum guifg=#00FF00 gui=bold") -- Green bold text for line number at stopped point

		-- Assign the custom highlight groups to the signs
		vim.fn.sign_define(
			"DapBreakpoint",
			{ text = "󰃤", texthl = "DapBreakpointText", linehl = "DapBreakpointLine", numhl = "DapBreakpointNum" }
		)
		vim.fn.sign_define(
			"DapStopped",
			{ text = "", texthl = "DapStoppedText", linehl = "DapStoppedLine", numhl = "DapStoppedNum" }
		)

		vim.keymap.set("n", "<leader>ttb", function()
			dap.toggle_breakpoint()
		end, { desc = "Toggle Breakpoint" })
		vim.keymap.set("n", "<F1>", dap.continue)
		vim.keymap.set("n", "<F2>", dap.step_into)
		vim.keymap.set("n", "<F3>", dap.step_over)
		vim.keymap.set("n", "<F4>", dap.step_out)
		vim.keymap.set("n", "<F5>", dap.step_back)
		vim.keymap.set("n", "<F13>", dap.restart)

		local ui = require("dapui")

		ui.setup({})

		dap.listeners.before.attach.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			ui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			ui.close()
		end
	end,
}
