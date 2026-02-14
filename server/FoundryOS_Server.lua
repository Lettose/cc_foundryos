comp_label = "fos_host"
protocol = "fos_server"

os.setComputerLabel(comp_label)
rednet.open("top")
rednet.host(protocol,comp_label)

user_passwords = {}

function io_load_credentials()
 
    local file = io.open("credentials.txt", "r")
    if not file then
        error("Failed to open file")
    end
 
    for line in file:lines() do
        local user, password = line:match("^(.-):(.-)$")
        if user and password then
            user_passwords[user] = password
        end
    end
    file:close()
 
end
 
 
function login_server()
    while true do
        local valid_bool = "false"
        local target_id,user,pass = rednet.receive()
        
        print("Recieved Login Request: ", target_id, user)
 
        for user_ls, pass_ls in pairs(user_passwords) do
            if user == user_ls and pass == pass_ls then
                valid_bool = "true"
            end
        end
        if valid_bool == "false" then
            print("Login Failed")
        else
            print("Login Succeeded")
        end
        
        rednet.send(target_id,valid_bool)
    end
end
 
io_load_credentials()
login_server()