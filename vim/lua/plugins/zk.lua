return {
	"zk-org/zk-nvim",
	name = "zk",
	opts = {
		picker = "snacks_picker",

		lsp = {
			-- `config` is passed to `vim.lsp.start(config)`
			config = {
				name = "zk",
				cmd = { "zk", "lsp" },
				filetypes = { "markdown" },
				-- on_attach = ...
				-- etc, see `:h vim.lsp.start()`
			},

			-- automatically attach buffers in a zk notebook that match the given filetypes
			auto_attach = {
				enabled = true,
			},
		}, -- See Setup section below
	},
	config = function()
		require("zk").setup({
			picker_options = {
				snacks_picker = {
					layout = { preset = "ivy" },
				},
			},
		})

		vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew<CR>", { desc = "New note" })
		vim.keymap.set("n", "<leader>zd", "<Cmd>ZkNew { dir = 'daily' }<CR>", { desc = "Daily note" })
		vim.keymap.set("n", "<leader>zf", "<Cmd>ZkNotes<CR>", { desc = "Find notes" })
		vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", { desc = "Tags" })
		vim.keymap.set("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", { desc = "Backlinks" })
		vim.keymap.set("n", "<leader>zl", "<Cmd>ZkLinks<CR>", { desc = "Links" })
	end,
}
