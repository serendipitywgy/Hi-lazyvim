return {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    config = function ()
        vim.g.gitblame_message_template = " <summary> • <date> • <author>"
        -- enables git-blame.nvim on Neovim startup
        vim.g.gitblame_enabled = 1
        -- start virtual text at column
        -- Have the blame message start at a given column instead of EOL.
        -- If the current line is longer than the specified column value
        -- the blame message will default to being displayed at EOL.
        vim.g.gitblame_virtual_text_column = 1
    end
}
