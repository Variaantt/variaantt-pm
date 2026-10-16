RegisterNetEvent("sendMessage")
AddEventHandler("sendMessage", function(typeMessage, message)
    print(message)
    SendNUIMessage({
        type = typeMessage;
        message = message;
    })
end)