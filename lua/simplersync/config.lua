-- Define a dotenv object
local dotenv = {}

-- Define a function to read a file and return its contents as a string
local function readFile(filename)
    -- Open the file in read mode
    local file = io.open(filename, "r")
    -- Check if the file exists
    if not file then
        -- Return nil and an error message
        return nil, "File not found: " .. filename
    end
    -- Read the whole file content
    local content = file:read("*a")
    -- Close the file
    file:close()
    -- Return the content
    return content
end

-- Define a function to parse a .env file and return a table of key-value pairs
local function parseEnv(content)
    -- Create an empty table to store the pairs
    local pairs = {}
    -- Loop through each line in the content
    for line in content:gmatch("[^\r\n]+") do
        -- Trim any leading or trailing whitespace from the line
        line = line:match("^%s*(.-)%s*$")
        -- Ignore empty lines or lines starting with #
        if line ~= "" and line:sub(1, 1) ~= "#" then
            -- Split the line by the first = sign
            local key, value = line:match("([^=]+)=(.*)")
            -- Trim any leading or trailing whitespace from the key and value
            key = key:match("^%s*(.-)%s*$")
            value = value:match("^%s*(.-)%s*$")
            -- Check if the value is surrounded by double quotes
            if value:sub(1, 1) == '"' and value:sub(-1, -1) == '"' then
                -- Remove the quotes and unescape any escaped characters
                value = value:sub(2, -2):gsub('\\"', '"')
            end
            -- Check if the value is surrounded by single quotes
            if value:sub(1, 1) == "'" and value:sub(-1, -1) == "'" then
                -- Remove the quotes
                value = value:sub(2, -2)
            end
            -- Store the key-value pair in the table
            pairs[key] = value
        end
    end
    -- Return the table
    return pairs
end

-- Define a function to load the environment variables from a .env file into the _G table
function dotenv.load(filedir)
    local t = {}
    -- Use .env as the default filename if not provided
    local filename = filedir .. ".nvim/simplersync.env"
    -- Read the file content
    local content, err = readFile(filename)
    -- Check if there was an error
    if not content then
        -- Return nil and the error message
        return nil, err
    end
    -- Parse the file content
    local parsed_content = parseEnv(content)
    -- Loop through the pairs
    for key, value in pairs(parsed_content) do
        -- Check if the key is not already in the _G table
        if not t[key] then
            -- Set the key-value pair in the _G table
            t[key] = value
        end
    end
    -- Return true
    return t
end

-- Return the dotenv object
return dotenv
