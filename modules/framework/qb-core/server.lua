if GetResourceState('qb-core') ~= 'started' then return end
if GetResourceState('qbx_core') == 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

Framework = {}

Framework.GetFrameworkName = function()
    return 'qb-core'
end

-- Framework.GetPlayerIdentifier(src)
-- Returns the citizen ID of the player.
Framework.GetPlayerIdentifier = function(src)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    return playerData.citizenid
end

-- Framework.GetPlayerName(src)
-- Returns the first and last name of the player.
Framework.GetPlayerName = function(src)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    return playerData.charinfo.firstname, playerData.charinfo.lastname
end

Framework.GetPlayerDob = function(src)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    return playerData.charinfo.birthdate
end

-- Framework.GetItem(src, item, metadata)
-- Returns a table of items matching the specified name and if passed metadata from the player's inventory.
-- returns {name = v.name, count = v.amount, metadata = v.info, slot = v.slot}
Framework.GetItem = function(src, item, metadata)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    local playerInventory = playerData.items
    local repackedTable = {}
    for _, v in pairs(playerInventory) do
        if v.name == item and (not metadata or v.info == metadata) then
            table.insert(repackedTable, {
                name = v.name,
                count = v.amount,
                metadata = v.info,
                slot = v.slot,
            })
        end
    end
    return repackedTable
end

-- Framework.GetItemCount(src, item, metadata)
-- Returns the count of items matching the specified name and if passed metadata from the player's inventory.
Framework.GetItemCount = function(src, item, metadata)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    local playerInventory = playerData.items
    local count = 0
    for _, v in pairs(playerInventory) do
        if v.name == item and (not metadata or v.info == metadata) then
            count = count + v.amount
        end
    end
    return count
end

-- Framework.GetPlayerInventory(src)
-- Returns the entire inventory of the player as a table.
-- returns {name = v.name, count = v.amount, metadata = v.info, slot = v.slot}
Framework.GetPlayerInventory = function(src)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    local playerInventory = playerData.items
    local repackedTable = {}
    for _, v in pairs(playerInventory) do
        table.insert(repackedTable, {
            name = v.name,
            count = v.amount,
            metadata = v.info,
            slot = v.slot,
        })
    end
    return repackedTable
end

Framework.GetItemBySlot = function(src, slot)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    local playerInventory = playerData.items
    local repack = {}
    for _, v in pairs(playerInventory) do
        if v.slot == slot then
            return {
                name = v.name,
                label = v.label,
                weight = v.weight,
                count = v.amount,
                metadata = v.info,
                slot = v.slot,
                stack = v.unique or false,
                description = v.description or "none",
            }
        end
    end
    return repack
end

-- Framework.SetMetadata(src, metadata, value)
-- Adds the specified metadata key and number value to the player's data.
Framework.SetPlayerMetadata = function(src, metadata, value)
    local player = QBCore.Functions.GetPlayer(src)
    player.Functions.SetMetaData(metadata, value)
    return true
end

-- Framework.GetMetadata(src, metadata)
-- Gets the specified metadata key to the player's data.
Framework.GetPlayerMetadata = function(src, metadata)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    return playerData.metadata[metadata] or false
end

-- Framework.AddStress(src, value)
-- Adds the specified value to the player's stress level and updates the client HUD.
Framework.AddStress = function(src, value)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    local newStress = playerData.metadata.stress + value
    player.Functions.SetMetaData('stress', Math.Clamp(newStress, 0, 100))
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    return newStress
end

-- Framework.RemoveStress(src, value)
-- Removes the specified value from the player's stress level and updates the client HUD.
Framework.RemoveStress = function(src, value)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    local newStress = (playerData.metadata.stress or 0) - value
    player.Functions.SetMetaData('stress', Math.Clamp(newStress, 0, 100))
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    return newStress
end

-- Framework.AddHunger(src, value)
-- Adds the specified value from the player's hunger level.
Framework.AddHunger = function(src, value)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    local newHunger = (playerData.metadata.hunger or 0) + value
    player.Functions.SetMetaData('hunger', Math.Clamp(newHunger, 0, 100))
    --TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    return newHunger
end

-- Framework.AddThirst(src, value)
-- Adds the specified value from the player's thirst level.
Framework.AddThirst = function(src, value)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    local newThirst = (playerData.metadata.thirst or 0) + value
    player.Functions.SetMetaData('thirst', Math.Clamp(newThirst, 0, 100))
    --TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    return newThirst
end

Framework.GetHunger = function(src)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    local newHunger = (playerData.metadata.hunger or 0)
    return newHunger
end

Framework.GetThirst = function(src)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    local newThirst = (playerData.metadata.thirst or 0)
    return newThirst
end

-- Framework.GetPlayerPhone(src)
-- Returns the phone number of the player.
Framework.GetPlayerPhone = function(src)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    return playerData.charinfo.phone
end

-- Framework.GetPlayerGang(src)
-- Returns the gang name of the player.
Framework.GetPlayerGang = function(src)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    return playerData.gang.name
end

-- Framework.GetPlayersByJob(jobname)
-- returns a table of player sources that have the specified job name.
Framework.GetPlayersByJob = function(job)
    local players = QBCore.Functions.GetPlayers()
    local playerList = {}
    for _, src in pairs(players) do
        local player = QBCore.Functions.GetPlayer(src).PlayerData
        if player.job.name == job then
            table.insert(playerList, src)
        end
    end
    return playerList
end

-- Framework.GetPlayerJob(src)
-- Returns the job name, label, grade name, and grade level of the player.
Framework.GetPlayerJob = function(src)
    local player = QBCore.Functions.GetPlayer(src)
    local playerData = player.PlayerData
    return playerData.job.name, playerData.job.label, playerData.job.grade.name, playerData.job.grade.level
end

-- Framework.SetPlayerJob(src, name, grade)
-- Sets the player's job to the specified name and grade.
Framework.SetPlayerJob = function(src, name, grade)
    local player = QBCore.Functions.GetPlayer(src)
    return player.Functions.SetJob(name, grade)
end

Framework.ToggleDuty = function(src, status)
    local player = QBCore.Functions.GetPlayer(src)
    player.Functions.SetJobDuty(status)
    TriggerEvent('QBCore:Server:SetDuty', src, player.PlayerData.job.onduty)
end

-- Framework.AddAccountBalance(src, _type, amount)
-- Adds the specified amount to the player's account balance of the specified type.
Framework.AddAccountBalance = function(src, _type, amount)
    local player = QBCore.Functions.GetPlayer(src)
    if _type == 'money' then _type = 'cash' end
    return player.Functions.AddMoney(_type, amount)
end

-- Framework.RemoveAccountBalance(src, _type, amount)
-- Removes the specified amount from the player's account balance of the specified type.
Framework.RemoveAccountBalance = function(src, _type, amount)
    local player = QBCore.Functions.GetPlayer(src)
    if _type == 'money' then _type = 'cash' end
    return player.Functions.RemoveMoney(_type, amount)
end

-- Framework.GetAccountBalance(src, _type)
-- Returns the player's account balance of the specified type.
Framework.GetAccountBalance = function(src, _type)
    local playerData = QBCore.Functions.GetPlayer(src).PlayerData
    if _type == 'money' then _type = 'cash' end
    return playerData.money[_type]
end

-- Framework.AddItem(src, item, amount, slot, metadata)
-- Adds the specified item to the player's inventory.
Framework.AddItem = function(src, item, amount, slot, metadata)
    local player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "add", item = item, count = amount, slot = slot, metadata = metadata})
    return player.Functions.AddItem(item, amount, slot, metadata)
end

-- Framework.RemoveItem(src, item, amount, slot, metadata)
-- Removes the specified item from the player's inventory.
Framework.RemoveItem = function(src, item, amount, slot, metadata)
    local player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("community_bridge:client:inventory:updateInventory", src, {action = "remove", item = item, count = amount, slot = slot, metadata = metadata})
    return player.Functions.RemoveItem(item, amount, slot or nil)
end

-- Framework.SetMetadata(src, item, slot, metadata)
-- Sets the metadata for the specified item in the player's inventory.
-- Notes, this is kinda a jank workaround. with the framework aside from updating the entire table theres not really a better way
Framework.SetMetadata = function(src, item, slot, metadata)
    local player = QBCore.Functions.GetPlayer(src)
    local slotFinder = Framework.GetPlayerInventory(src)
    local freeSlot = Table.FindFirstUnoccupiedSlot(slotFinder)
    local itemSlot = slot or nil
    if itemSlot == nil then
        for _, v in pairs(slotFinder) do
            if v.name == item then
                slot = v.slot
                break
            end
        end
    end
    player.Functions.RemoveItem(item, 1, itemSlot)
    return player.Functions.AddItem(item, 1, freeSlot, metadata)
end

Framework.GetOwnedVehicles = function(src)
    local citizenId = Framework.GetPlayerIdentifier(src)
    local result = MySQL.Sync.fetchAll("SELECT vehicle, plate FROM player_vehicles WHERE citizenid = '" .. citizenId .. "'")
    local vehicles = {}
    for i=1, #result do
        local vehicle = result[i].vehicle
        local plate = result[i].plate
        table.insert(vehicles, {vehicle = vehicle, plate = plate})
    end
    return vehicles
end

-- Framework.RegisterUsableItem(item, cb)
-- Registers a usable item with a callback function.
Framework.RegisterUsableItem = function(itemName, cb)
    local func = function(src, item, itemData)
        itemData = itemData or item
        itemData.metadata = itemData.metadata or itemData.info or {}
        cb(src, itemData)
    end
    QBCore.Functions.CreateUseableItem(itemName, func)
end

RegisterNetEvent("QBCore:Server:OnPlayerUnload", function()
    local src = source
    TriggerEvent("community_bridge:Server:OnPlayerUnload", src)
end)

AddEventHandler("playerDropped", function()
    local src = source
    TriggerEvent("community_bridge:Server:OnPlayerUnload", src)
end)

Framework.Commands = {}
Framework.Commands.Add = function(name, help, arguments, argsrequired, callback, permission, ...)
    QBCore.Commands.Add(name, help, arguments, argsrequired, callback, permission, ...)
end