RegisterNetEvent("sendMessage")
AddEventHandler("sendMessage", function(typeMessage, message)
    if typeMessage == "msg" or typeMessage == "answer" then
        print(message)
    end
    
    SendNUIMessage({
        type = typeMessage;
        message = message;
    })
end)