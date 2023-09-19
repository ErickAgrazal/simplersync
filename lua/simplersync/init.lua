vim.api.nvim_create_user_command("RsyncTesting", function(opts)
    local remoteDir = opts.fargs[1]
    local localFile = vim.fn.expand("%:.")
    print(remoteDir)
    print(localFile)
end, {
    nargs = 1,
    complete = function(ArgLead, CmdLine, CursoPos)
        return { "disable", "toggle", "enable" }
    end,
})
