return {
	opts = {
		enabled = true,
		replace_netrw = true,
	},

	keys = function()
		vim.keymap.set("n", "<leader>e", "<cmd>lua Snacks.explorer()<CR>", { desc = "Toggle explorer" })
	end,
}
