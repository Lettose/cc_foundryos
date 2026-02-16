comp_label = "fos_host"
protocol = "fos_server"

os.setComputerLabel(comp_label)
rednet.open("top")
rednet.host(protocol,comp_label)

filename = "credentials.txt"

user_passwords = {}
user_role = {}

function io_load_credentials()
 
    local file = io.open(filename, "r")
    if not file then
        error("Failed to open file")
    end
 
    for line in file:lines() do
        local user, password, role = line:match("^(.-):(.-):(.-)$")
        if user and password then
            user_passwords[user] = password
            user_role[user] = role
        end
    end
    file:close()
 
end
 


function updatePassword(targetUser, newPassword)
    local lines = {}
    local found = false
    local valid_flag = "false"
    
    -- 1. Read all lines into a table
    if fs.exists(filename) then
        local file = fs.open(filename, "r")
        local line = file.readLine()
        while line do
            -- 2. Split line by colons (user:pass:role)
            local parts = {}
            for part in string.gmatch(line, "([^:]+)") do
                table.insert(parts, part)
            end
            
            -- 3. Check if this is the user we want to update
            if parts[1] == targetUser then
                -- Rebuild the line with the new password
                line = parts[1] .. ":" .. newPassword .. ":" .. (parts[3] or "user")
                found = true
            end
            
            table.insert(lines, line)
            line = file.readLine()
        end
        file.close()
    end

    -- 4. Overwrite the file with the updated table
    if found then
        local file = fs.open(filename, "w")
        for _, l in ipairs(lines) do
            file.writeLine(l)
        end
        file.close()
        print("Password updated for " .. targetUser)

        valid_flag = "true"
        io_load_credentials()
    else
        print("User not found.")
    end
    return valid_flag
end


 
function loginServer()
    while true do
        local valid_flag = "false"
        local role = nil
        local target_id,message,protocol = rednet.receive()

        if protocol == "login_request" then
            local user = message[1]
            local pass = message[2]

            print("Recieved Login Request: ", target_id, user)
            
            for user_ls, pass_ls in pairs(user_passwords) do
                if user == user_ls and pass == pass_ls then
                    role = user_role[user]
                    valid_flag = "true"
                end
            end
            if valid_flag == "false" then
                print("Login Failed")
            else
                print("Login Succeeded")
            end
            
            message = {valid_flag,role}

            rednet.send(target_id,message,"login_request")
        
        elseif protocol == "reset_pass" then
            local user = message[1]
            local pass = message[2]
            
            print("Recieved Reset Password Request: ", target_id, user)
            message = updatePassword(user,pass)

            rednet.send(target_id,message,"reset_pass")
        end
    end
end

cls()

io_load_credentials()
loginServer()