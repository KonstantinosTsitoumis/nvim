return {
	"ranelpadon/python-copy-reference.vim",
	config = function()
		local keymap = vim.keymap

		keymap.set("n", "<leader>yr", ":PythonCopyReferenceDotted<CR>", { desc = "Yank Pycharm-like reference" })
		keymap.set("n", "<leader>yi", ":PythonCopyReferenceDotted<CR>", { desc = "Yank to python import" })
	end,
}
