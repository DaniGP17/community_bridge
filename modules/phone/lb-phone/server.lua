if GetResourceState('lb-phone') ~= 'started' or (BridgeSharedConfig.Phone ~= "lb-phone" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

Phone = {}

Phone.GetPlayerPhone = function(src)
    return exports["lb-phone"]:GetEquippedPhoneNumber(src) or false
end

Phone.SendEmail = function(src, email, title, message)
    local numberNumber = exports["lb-phone"]:GetEquippedPhoneNumber(src)
    if not numberNumber then return false, Prints.Error("Could not Find Phone number") end
    local playerEmail = exports["lb-phone"]:GetEmailAddress(numberNumber)
    if not playerEmail then return false, Prints.Error("Could not Find email")  end
    local success, id = exports["lb-phone"]:SendMail({
        to = playerEmail,
        sender = email,
        subject = title,
        message = message,
    })
    return success
end

RegisterNetEvent('community_bridge:Server:genericEmail', function(data)
    local src = source
    Prints.Debug('community_bridge:Server:genericEmail Hit')
    return Phone.SendEmail(src, data.email, data.title, data.message)
end)