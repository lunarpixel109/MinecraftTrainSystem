
function displayNextTrain()

    term.clear()
    term.setBackgroundColor(colors.lightBlue)
    term.setTextColor(colors.white)

    term.setCursorBlink(false)
    

    term.setCursorPos(0, 0)
    print(textutils.formatTime(os.time(), false))
    term.setCursorPos(12, 0)
    print(currentNextTrain.title)
    term.setCursorPos(0, 1)
    print(currentNextTrain.callingAt)
    term.setCursorPos(0, 2)
    print(table.concat({currentNextTrain.platform, "     ", currentNextTrain.length}))
    
end

function announce(message)
    term.setBackgroundColor(colors.red)
    term.setTextColor(colors.white)
    print(message)
end


currentNextTrain = {nextTrainTime = 0, title = "No Train Data", callingAt = "No Information. PLease check timetable", length = "N/A Coaches", platform = 0}

local monitor = peripheral.wrap("bottom")

monitor.setTextScale(0.5)

term.setBackgroundColor(colors.lightBlue)
rednet.open("top")

displayNextTrain()

while true do
    local _, message, protocol = rednet.receive()
    if protocol == "next_train_information" then
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
