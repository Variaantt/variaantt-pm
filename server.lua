local lastMessengers = {}

RegisterCommand("pm", function(source, args, rawCommand)
    if args[1] ~= nil then
        local id = tonumber(args[1])
        if id ~= nil and id > 0 then
            local addressee = GetPlayerName(id)
            if addressee ~= nil then
                local sender = GetPlayerName(source)
                local message = table.concat(args, " ", 2)
                if message ~= "" then
                    TriggerClientEvent("sendMessage", id, "msg", "Message from "..sender.." | ID ("..source..") : "..message)
                    TriggerClientEvent("sendMessage", source, "success", "Message to "..addressee.." ID ("..id..") sent")
                    lastMessengers[id] = source
                else
                    TriggerClientEvent("sendMessage", source, "error", "Error: The message cannot be empty")
                end
            else
                TriggerClientEvent("sendMessage", source, "error", "Error: Not a valid ID")
            end
        else
            TriggerClientEvent("sendMessage", source, "error", "Error: Not a valid ID")
        end
    else
        TriggerClientEvent("sendMessage", source, "error", "Error: Not valid parameters")
    end
end, false)

RegisterCommand("r", function(source, args, rawCommand)
    if lastMessengers[source] ~= nil then
        local lastMessengerID = lastMessengers[source]
        local addressee = GetPlayerName(lastMessengerID)
        if addressee ~= nil then
            local sender = GetPlayerName(source)
            local message = table.concat(args, " ", 1)
            if message ~= "" then
                TriggerClientEvent("sendMessage", lastMessengerID, "answer", "Answer from "..sender.." | ID ("..source..") : "..message)
                TriggerClientEvent("sendMessage", source, "success", "Answer to "..addressee.." ID ("..lastMessengerID..") sent")
                lastMessengers[lastMessengerID] = source
            else
                TriggerClientEvent("sendMessage", source, "error", "Error: The message cannot be empty")
            end
        else
            TriggerClientEvent("sendMessage", source, "error", "Error: No one to answer")
            lastMessengers[source] = nil
        end
    else
        TriggerClientEvent("sendMessage", source, "error", "Error: No one to answer")
    end
end, false)