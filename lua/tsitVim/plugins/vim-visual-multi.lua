return {
	"mg979/vim-visual-multi",
	init = function()
		vim.g.VM_default_mappings = 0
		vim.g.VM_maps = {
			["Select Cursor Down"] = "<M-n>",
			["Select Cursor Up"] = "<M-m>",
		}
	end,
}
