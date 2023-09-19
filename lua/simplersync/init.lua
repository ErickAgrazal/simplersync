local sync = require("simplersync.sync")

vim.api.nvim_create_user_command("RsyncSimple", function(opts)
    local current_dir = vim.fn.expand("%:p:h")
    local local_file = vim.fn.expand("%:.")
    sync.sync_up(local_file, current_dir)
end, {
    nargs = "?",
    complete = function(ArgLead, CmdLine, CursoPos)
        return { "disable", "toggle", "enable" }
    end,
})
