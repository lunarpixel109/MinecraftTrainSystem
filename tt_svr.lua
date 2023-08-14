
rednet.open("left")
rednet.host("server_admin", "lower_tt_server")
rednet.broadcast("restart", "server_admin")

function runServerCommand()
    -- TODO: Create control HTTP Server
end

function updateTimeTable() 
    -- TODO: Create timetable HTTP server in real world

end

while true do
    parallel.waitForAny(runServerCommand, updateTimeTable)
end