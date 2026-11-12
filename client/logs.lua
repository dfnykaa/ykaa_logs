local dead = false

AddEventHandler('gameEventTriggered', function(name, args)
    if name ~= 'CEventNetworkEntityDamage' then return end

    local victim = args[1]
    local attacker = args[2]
    local victimDied = args[6]
    local weaponHash = args[7]

    if victim ~= PlayerPedId() then return end
    if victimDied ~= 1 then return end
    if dead then return end
    dead = true

    local ped = PlayerPedId()

    if not weaponHash or weaponHash == 0 then
        weaponHash = GetPedCauseOfDeath(ped)
    end

    local killerId = -1
    local killerType = 'environment'
    local distance = 0.0

    if attacker and attacker ~= 0 and DoesEntityExist(attacker) then
        if attacker == ped then
            killerType = 'suicide'
        elseif IsEntityAVehicle(attacker) then
            local driver = GetPedInVehicleSeat(attacker, -1)
            if driver ~= 0 and IsPedAPlayer(driver) then
                local idx = NetworkGetPlayerIndexFromPed(driver)
                if idx and idx ~= -1 then
                    killerId   = GetPlayerServerId(idx)
                    killerType = 'player'
                end
            else
                killerType = 'vehicle'
            end
        elseif IsPedAPlayer(attacker) then
            local idx = NetworkGetPlayerIndexFromPed(attacker)
            if idx and idx ~= -1 then
                killerId = GetPlayerServerId(idx)
                killerType = 'player'
            end
        else
            killerType = 'npc'
        end

        if killerType ~= 'suicide' then
            distance = #(GetEntityCoords(ped) - GetEntityCoords(attacker))
        end
    end

    local c = GetEntityCoords(ped)
    local vehicleName = nil
    local veh = GetVehiclePedIsIn(ped, true)
    if veh and veh ~= 0 then
        vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
    end

    TriggerServerEvent('ykaa_logs:playerDied', killerId, weaponHash, killerType,
        { x = c.x, y = c.y, z = c.z }, distance, vehicleName)
end)

CreateThread(function()
    while true do
        Wait(500)
        if dead then
            local ped = PlayerPedId()
            if not IsEntityDead(ped) and not IsPedFatallyInjured(ped) then
                dead = false
            end
        end
    end
end)