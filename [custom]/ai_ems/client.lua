RegisterCommand("help", function()
    -- Check if player is dead
    local inDead = exports.qbx_medical:IsDead()
    local inLaststand = exports.qbx_medical:IsLaststand()

    -- Check if player is dead (multiple methods)
    local isDead = (
        inDead or inLaststand
    )

    if not isDead then
        exports.qbx_core:Notify("You are not dead!", "error", 5000)
        return
    end

    -- Start revive progress bar
    if lib.progressBar({
        duration = 5000,
        label = "Receiving emergency treatment...",
        useWhileDead = true,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    }) then
        -- Successfully completed progress
        TriggerEvent("qbx_medical:client:playerRevived")
        exports.qbx_core:Notify("Emergency services have revived you!", "success", 5000)
    else
        -- Cancelled progress
        exports.qbx_core:Notify("Medical request cancelled", "error", 5000)
    end
end, false)