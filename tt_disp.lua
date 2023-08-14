
function displayNextTrain()

    term.clear()
    term.setBackgroundColor(colors.lightBlue)
    term.setTextColor(colors.white)

    term.setCursorBlink(false)
    


    print(textutils.formatTime(os.time(), false))
    print(currentNextTrain.title)
    print(currentNextTrain.callingAt)
    print(table.concat({currentNextTrain.platform, "     ", currentNextTrain.length}))
    
end

function announce(message)
    term.setBackgroundColor(colors.red)
    term.setTextColor(colors.white)
    term.clear()
    print(message)
end


currentNextTrain = {nextTrainTime = 0, title = "No Train Data", callingAt = "No Information. PLease check timetable", length = "NaN Coaches", platform = "NaN"}

local monitor = peripheral.wrap("bottom")

monitor.setTextScale(0.5)

term.setBackgroundColor(colors.lightBlue)
rednet.open("top")

local controlHost = rednet.lookup("system_admin")

displayNextTrain()
isActive = true;
while isActive do
    local senderID, message, protocol = rednet.receive()
    if senderID == controlHost and protocol == "system_admin" then
        if message == "shutdown" then
            os.shutdown()
        elseif message == "restart" then
            os.reboot()
        elseif message == "exit" then
            isActive = false
            return
        end
    elseif protocol == "next_train_information" then
        local split = string.gmatch(message, ":")
        currentNextTrain.nextTrainTime = split[1]
        currentNextTrain.title = split[2]
        currentNextTrain.callingAt = split[3]
        currentNextTrain.length = split[4]
        currentNextTrain.platform = split[5]
        displayNextTrain()
    elseif protocol == "emergency_announcement" then
        announce(message)
    end
end

rednet.close()
announce("Offline")
