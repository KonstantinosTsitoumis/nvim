return {
	"stevanmilic/nvim-lspimport",
	config = function()
		vim.keymap.set("n", "<leader>ci", require("lspimport").import, { noremap = true })
	end,
}
