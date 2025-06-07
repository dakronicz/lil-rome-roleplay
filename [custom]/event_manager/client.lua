RegisterCommand("startevent", function(_, args)
    local eventId = args[1]
    if not eventId then
        print("Usage: /startevent [eventId]")
        return
    end
    TriggerServerEvent('eventmanager:startEvent', eventId)
end)

RegisterCommand("joinevent", function(_, args)
    local eventId = args[1]
    if not eventId then
        print("Usage: /joinevent [eventId]")
        return
    end
    TriggerServerEvent('eventmanager:joinEvent', eventId)
end)

RegisterCommand("endevent", function(_, args)
    local eventId = args[1]
    if not eventId then
        print("Usage: /endevent [eventId]")
        return
    end
    TriggerServerEvent('eventmanager:endEvent', eventId)
end)

RegisterCommand("leaveevent", function(_, args)
    local eventId = args[1]
    if not eventId then
        print("Usage: /leaveevent [eventId]")
        return
    end

    TriggerServerEvent('eventmanager:leaveEvent', eventId)
end)

RegisterCommand("myevents", function()
    TriggerServerEvent("eventmanager:getJoinedEvents")
end)

RegisterCommand("giveloadout", function(_, args)
    local loadoutType = args[1] or "default"
    TriggerServerEvent("eventmanager:giveLoadout", loadoutType)
end, false)

RegisterNetEvent("eventmanager:receiveJoinedEvents", function(events)
    if #events == 0 then
        print("You are not currently in any events.")
    else
        print("You are in the following events:")
        for _, eventId in ipairs(events) do
            print("- " .. eventId)
        end
    end
end)

RegisterNetEvent('eventmanager:joinedEvent', function(eventId)
    print("You have joined the event: " .. tostring(eventId))
    -- OPTIONAL: Add teleport, blips, or PvP enabling here
end)