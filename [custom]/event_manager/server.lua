local QBCore = exports['qb-core']:GetCoreObject()

local events = {}

RegisterNetEvent('eventmanager:startEvent', function(eventId)
    local src = source

    if not eventId or eventId == "" then
        TriggerClientEvent('QBCore:Notify', src, 'You must specify an event ID.', 'error')
        return
    end

    if events[eventId] then
        TriggerClientEvent('QBCore:Notify', src, 'An event with this ID is already running.', 'error')
        return
    end

    events[eventId] = {
        host = src,
        players = { [src] = true }
    }

    ClearPlayerInventory(src)
    GiveLoadoutToPlayer(src, "default") -- Give the host a default loadout
    TriggerClientEvent('QBCore:Notify', src, 'Event started! Others can now join.', 'success')
    TriggerClientEvent('eventmanager:joinedEvent', src, eventId)
end)

RegisterNetEvent('eventmanager:joinEvent', function(eventId)
    local src = source

    if not events[eventId] then
        TriggerClientEvent('QBCore:Notify', src, 'No such event is running.', 'error')
        return
    end

    if events[eventId].players[src] then
        TriggerClientEvent('QBCore:Notify', src, 'You already joined this event.', 'error')
        return
    end

    events[eventId].players[src] = true

    ClearPlayerInventory(src)
    GiveLoadoutToPlayer(src, "default") -- Give the host a default loadout
    TriggerClientEvent('QBCore:Notify', src, 'You have joined the event.', 'success')
    TriggerClientEvent('eventmanager:joinedEvent', src, eventId)
end)

RegisterNetEvent('eventmanager:endEvent', function(eventId)
    local src = source

    local event = events[eventId]
    if not event then
        TriggerClientEvent('QBCore:Notify', src, 'No such event is running.', 'error')
        return
    end

    if event.host ~= src then
        TriggerClientEvent('QBCore:Notify', src, 'Only the event host can end this event.', 'error')
        return
    end

    for id in pairs(event.players) do
        if Config.RevivePlayersAtEnd then
            TriggerClientEvent('qbx_medical:client:playerRevived', id)
        end
        TriggerClientEvent('QBCore:Notify', id, 'The event has ended.', 'primary')
    end

    events[eventId] = nil
end)

RegisterNetEvent('eventmanager:leaveEvent', function(eventId)
    local src = source
    local event = events[eventId]

    if event and event.players[src] then
        event.players[src] = nil
        TriggerClientEvent('QBCore:Notify', src, 'You have left the event.', 'info')
    else
        TriggerClientEvent('QBCore:Notify', src, 'You are not part of this event.', 'error')
    end
end)

RegisterNetEvent('eventmanager:getJoinedEvents', function()
    local src = source
    local joinedEvents = {}

    for eventId, event in pairs(events) do
        if event.players[src] then
            table.insert(joinedEvents, eventId)
        end
    end

    TriggerClientEvent('eventmanager:receiveJoinedEvents', src, joinedEvents)
end)

RegisterNetEvent("eventmanager:giveLoadout", function(loadoutType)
    local src = source
    ClearPlayerInventory(src)
    GiveLoadoutToPlayer(src, loadoutType)
end)

function GiveLoadoutToPlayer(playerId, loadoutType)
    local Player = QBCore.Functions.GetPlayer(playerId)
    loadoutType = loadoutType or "default"
    local loadout = Config.CustomLoadouts[loadoutType]

    if not Player or not loadout then
        TriggerClientEvent("QBCore:Notify", playerId, "Invalid loadout type!", "error")
        return
    end

    for _, item in pairs(loadout) do
        Player.Functions.AddItem(item.name, item.count or 1, false)
    end

    TriggerClientEvent("QBCore:Notify", playerId, loadoutType .. " loadout equipped.", "success")
end

function ClearPlayerInventory(playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if Player then
        Player.Functions.ClearInventory()
        TriggerClientEvent("QBCore:Notify", playerId, "Your inventory has been cleared.", "error")
    end
end
