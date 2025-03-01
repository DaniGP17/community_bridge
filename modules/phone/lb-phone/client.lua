if GetResourceState('lb-phone') ~= 'started' or (BridgeSharedConfig.Phone ~= "lb-phone" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

Phone = {}

Phone.SendEmail = function(email, title, message)
    TriggerServerEvent('community_bridge:Server:genericEmail', {email = email, title = title, message = message})
end