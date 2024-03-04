local M = {}

local sync = require("simplersync.sync")

local function execute_sync_up()
    local current_dir = vim.fn.expand("%:p:h")
    local local_file = vim.fn.expand("%:.")
    sync.sync_up(local_file, current_dir)
end

local function execute_sync_down()
    local current_dir = vim.fn.expand("%:p:h")
    local local_file = vim.fn.expand("%:.")
    sync.sync_down(local_file, current_dir)
end

vim.api.nvim_create_user_command("SimpleRsyncUp", execute_sync_up, {
    nargs = "?",
    complete = function(arglead, cmdline, cursopos)
        return { "disable", "toggle", "enable" }
    end,
})

vim.api.nvim_create_user_command("SimpleRsyncDown", execute_sync_down, {
    nargs = "?",
    complete = function(arglead, cmdline, cursopos)
        return { "disable", "toggle", "enable" }
    end,
})

M.execute_sync_up = execute_sync_up
M.execute_sync_down = execute_sync_down

return M