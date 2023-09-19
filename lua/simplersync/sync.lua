local log = require("simplersync.log")

local sync = {}

local function split_by(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

--- Tries to start job and repors errors if any where found
local function safe_sync(command)
    vim.fn.jobstart(command, {
        on_stderr = function(_, output, _)
            -- skip when function reports empty error
            if vim.inspect(output) ~= vim.inspect({ "" }) then
                log.info(string.format("safe_sync command: '%s', on_stderr: '%s'", command, vim.inspect(output)))
            end
        end,

        -- job done executing
        on_exit = function(_, code, _)
            if code ~= 0 then
                log.info(string.format("safe_sync command: '%s', on_exit with code = '%s'", command, code))
            end
        end,
        stdout_buffered = true,
        stderr_buffered = true,
    })
end

local function create_filters(path)
    local f = io.open(path, "r")

    local include = " "
    local exclude = " "
    if f ~= nil then
        for line in f:lines() do
            if line:sub(1, 1) == "!" then
                include = include .. "--include='" .. line:sub(2, -1) .. "' "
            else
                exclude = exclude .. "--exclude='" .. line .. "' "
            end
        end
    end
    return include, exclude
end

local function compose_sync_up_command(local_filename, remote)
    -- read .gitignore append lines without ! with --include
    local include, exclude = create_filters(".gitignore")
    return "rsync -varz --delete" .. include .. exclude .. local_filename .. " " .. remote
end

function sync.sync_up(filename, remote)
    local remote_dir_table = split_by(filename, "/")
    local remote_dir = table.concat(remote_dir_table, "/", 1, #remote_dir_table - 1)
    local cmd = compose_sync_up_command(filename, remote .. remote_dir)
    safe_sync(cmd)
end

return sync
