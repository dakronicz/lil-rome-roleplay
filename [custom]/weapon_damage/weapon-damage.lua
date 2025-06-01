Citizen.CreateThread(function()
    while true do
        Wait(100)
        
        local playerPed = PlayerPedId()
        local weaponsConfig = Config.WeaponsDamage[GetSelectedPedWeapon(playerPed)]
        
        if weaponsConfig then
            if weaponsConfig.disableCriticalHits then
                SetPedSuffersCriticalHits(playerPed, false)
            end
            N_0x4757f00bc6323cfe(weaponsConfig.model, weaponsConfig.modifier)
        else
            Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
	    DisableControlAction(1, 140, true)
       	   DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end
    end
end)