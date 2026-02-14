local pos = term.setCursorPos
local cls = term.clear
local box = paintutils.drawFilledBox
local outline = paintutils.drawBox
local line = paintutils.drawLine 
local tCol = term.setTextColor
local bCol = term.setBackgroundColor
local rsget = rs.getAnalogInput
local rsset = rs.setAnalogOutput
 
x,y = term.getSize()
 
----------------------------------------------

curr_state = 1
username = ""
 
rednet.open("top")
login_val_ip = rednet.lookup("fos_server","fos_host")

btn1_width = 16
btn1_height = 2
btn1_color = colors.lightGray
btn1_text_color = colors.black

logo = [[
    ___                 _             ___  ___ 
   | __|__ _  _ _ _  __| |_ _ _  _   / _ \/ __|
   | _/ _ \ || | ' \/ _` | '_| || | | (_) \__ \
   |_|\___/\_,_|_||_\__,_|_|  \_, |  \___/|___/
                              |__/                        
]]
 
 
function login_client(user, pass)
    rednet.send(login_val_ip,user, pass)
 
    local valid_bool = false
    local sender_id,message = rednet.receive(nil, 5)  
 
    if sender_id == login_val_ip then
        if message == "true" then
            valid_bool = true
            username = user
        else
            write("Incorrect Login")
        end
    else
        printError("Couldn't Validate")
    end
 
    return valid_bool
end
 
-----------------------------------------------
 
 
function drawLoginMenu()
    pos(1,1)
    box(1,1,x,y,colors.black) -- Background
    box(12,11,40,16,colors.gray) -- Login Menu
    line(12,11,40,11,colors.lightGray) -- Top Bar
    line(23,13,38,13,colors.black) -- User
    line(23,15,38,15,colors.black) -- Pass
 
    tCol(colors.orange)
    bCol(colors.black)
    pos(1,3)
    write(logo)
    
    tCol(colors.lightGray)
    pos(13,8)
    write("Industrial Control System")
 
    tCol(colors.orange)
    bCol(colors.gray)
    pos(14,13)
    write("Username")
    pos(14,15)
    write("Password")
 
    tCol(colors.white)
    bCol(colors.black)
end
 


function drawWindowTemplate()
    pos(1,1)
    local print_str = ""
    local str_len = 0
    
    box(2,2,x-1,y-1,colors.gray) --Background
    line(2,2,x-1,2,colors.lightGray) -- Top Bar
    line(x-3,2,x-1,2,colors.red) --Exit
 
    -- Exit Button
    tCol(colors.black)
    bCol(colors.red)
    pos(x-2,2)
    write("x")

    -- Back Button
    if curr_state>1 then
        tCol(colors.black)
        bCol(colors.orange)
        pos(x-6,2)
        write(" - ")
    end
    
    -- Header Info
    bCol(colors.lightGray)
    tCol(colors.black)
    print_str = "[Foundry OS]"
    pos(2,2)
    write(print_str)

    -- Header Info
    if curr_state==1 then
        print_str = "Home"
    elseif curr_state==2 then
        print_str = "System Info"
    elseif curr_state==3 then
        print_str = "Power Network"
    elseif curr_state==4 then
        print_str = "Train Network"
    elseif curr_state==5 then
        print_str = "User Info"
    end
    pos(x/2-(string.len(print_str)/2)+1,2)
    write(print_str)
end
 


function drawHomePage()
    drawWindowTemplate()
    local st_pos = 0
    local end_pos = 0

    -- Welcome Message
    bCol(colors.gray)
    tCol(colors.orange)
    print_str = "Welcome, "..username.."!"
    str_len = math.floor(string.len(print_str)/2)-1
    pos(0.25*x-str_len,5)
    write(print_str)

    -- System Info Button
    st_posx = 30
    st_posy = 5
    
    for i=3, 1, -1 do
        box(st_posx,st_posy,st_posx+btn1_width,st_posy+btn1_height,btn1_color)
        st_posy = st_posy + btn1_height + 3
    end

    st_posx = 5
    st_posy = 15
    box(st_posx,st_posy,st_posx+btn1_width,st_posy+btn1_height,btn1_color)

    bCol(btn1_color)
    tCol(btn1_text_color)
    pos(33,6)
    print_str = "System Info"
    write(print_str)

    pos(32,11)
    print_str = "Power Network"
    write(print_str)

    pos(32,16)
    print_str = "Train Network"
    write(print_str)

    pos(9,16)
    print_str = "User Info"
    write(print_str)
end



function drawSystemInfoPage()
    drawWindowTemplate()
end



function drawPowerNetworkPage()
    drawWindowTemplate()
end



function drawTrainNetworkLoop()
    drawWindowTemplate()
end



function drawUserInfoLoop()
    drawWindowTemplate()
end


 
function homePageLoop()
    drawHomePage()
 
    while true do 
        local event, button, mx, my = os.pullEvent()
 
        if event == "mouse_click" then 
            if mx >= x-3 and mx <= x-1 and my == 2 and button == 1 then  
                drawLoginMenu()
                curr_state = 0
                break
            elseif mx >= 30 and mx <= 30+btn1_width and my >= 5 and my <= 5+btn1_height and button == 1 then
                curr_state = 2
                break
            elseif mx >= 30 and mx <= 30+btn1_width and my >= 10 and my <= 10+btn1_height and button == 1 then
                curr_state = 3
                break
            elseif mx >= 30 and mx <= 30+btn1_width and my >= 15 and my <= 15+btn1_height and button == 1 then
                curr_state = 4
                break
            elseif mx >= 5 and mx <= 5+btn1_width and my >= 15 and my <= 15+btn1_height and button == 1 then
                curr_state = 5
                break
            end
        end
    end
end



function systemInfoPageLoop()
    drawSystemInfoPage()
 
    while true do 
        local event, button, mx, my = os.pullEvent()
 
        if event == "mouse_click" then 
            if mx >= x-3 and mx <= x-1 and my == 2 and button == 1 then  
                drawLoginMenu()
                curr_state = 0
                break
            elseif mx >= x-6 and mx <= x-4 and my == 2 and button == 1 then  
                curr_state = 1
                break
            end
        end
    end
end
 
 

function powerNetworkLoop()
    drawPowerNetworkPage()
 
    while true do 
        local event, button, mx, my = os.pullEvent()
 
        if event == "mouse_click" then 
            if mx >= x-3 and mx <= x-1 and my == 2 and button == 1 then  
                drawLoginMenu()
                curr_state = 0
                break
            elseif mx >= x-6 and mx <= x-4 and my == 2 and button == 1 then  
                curr_state = 1
                break
            end
        end
    end
end
 


function trainNetworkLoop()
    drawTrainNetworkLoop()
 
    while true do 
        local event, button, mx, my = os.pullEvent()
 
        if event == "mouse_click" then 
            if mx >= x-3 and mx <= x-1 and my == 2 and button == 1 then  
                drawLoginMenu()
                curr_state = 0
                break
            elseif mx >= x-6 and mx <= x-4 and my == 2 and button == 1 then  
                curr_state = 1
                break
            end
        end
    end
end



function userInfoLoop()
    drawUserInfoLoop()
 
    while true do 
        local event, button, mx, my = os.pullEvent()
 
        if event == "mouse_click" then 
            if mx >= x-3 and mx <= x-1 and my == 2 and button == 1 then  
                drawLoginMenu()
                curr_state = 0
                break
            elseif mx >= x-6 and mx <= x-4 and my == 2 and button == 1 then  
                curr_state = 1
                break
            end
        end
    end
end



function timeLoop() -- Prints Time in Top Left
 
 
    while true do
        while curr_state > 0 do
            cur_pos1, cur_pos2 = term.getCursorPos()
            cur_bCol = term.getBackgroundColor()
            cur_tCol = term.getTextColor()
            cur_time = textutils.formatTime(os.time("local"))
            time_str_len_offset = math.floor(string.len(cur_time)) / 2 - 1
        
            pos((x / 2) - time_str_len_offset,2)
            bCol(colors.lightGray)
            tCol(colors.black)
            write(cur_time)
        
            pos(cur_pos1, cur_pos2) 
            bCol(cur_bCol)
            tCol(cur_tCol)
            
            os.sleep(0.05)
        end
        os.sleep(0.05)
    end
end
 
 
 
function main()
    cls()
    drawLoginMenu()
 
    while true do
        if curr_state == 0 then
            tCol(colors.white)
            bCol(colors.black)
            pos(23,13)
            user_in = read()
            pos(23,15)
            pass_in = read("*")
            
            tCol(colors.red)
            bCol(colors.black)
        
            pos(19,18)
 
            local valid_login = login_client(user_in, pass_in)
            
            if valid_login == true then
                curr_state = 1
            else
                os.sleep(1)
            
                drawLoginMenu()
            end
        elseif curr_state == 1 then
            homePageLoop()
        elseif curr_state == 2 then
            systemInfoPageLoop()
        elseif curr_state == 3 then
            powerNetworkLoop()
        elseif curr_state == 4 then
            trainNetworkLoop()
        elseif curr_state == 5 then
            userInfoLoop()
        end
    end
end
 
 
 
-----------------------------------------------
 
 
 
parallel.waitForAll(main)
 