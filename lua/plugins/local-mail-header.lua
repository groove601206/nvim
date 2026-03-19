return {
	{
		"local-mail-header",
		dir = vim.fn.stdpath("config") .. "/lua/mail_header",
		name = "mail-header",
		event = "FileType mail",
		config = function()
			require("mail_header")
		end,
	},
}
