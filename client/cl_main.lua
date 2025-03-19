resourceName = GetCurrentResourceName()
QBCore = exports["qb-core"]:GetCoreObject()
PlayerChar = {}
PlayerJob = {}
playerCash = nil
playerBank = nil
jobname = nil
jobrank = nil
citizenid = nil
playerid = nil
xPlayerId = nil -- Player Server Id
onDuty = nil
ped = nil
aopChoices = nil
aopTChoices = nil
ActivePlayers = 0
talking = false
isUnderwater = false
local showCircleB = false
local showSquareB = false
local maxPlayerSlots = cfg.Settings['maxPlayers']



-- AOP --
local CurrentAOP = cfg.aopSettings['defaultAop'] 

-- Hud functions --
HUD = {}
HUD.serverId = nil
Heading = nil

-- Street Label --
-- local coords = nil;
-- local streetName, crossing = nil
-- local streetName = nil
-- local crossing = nil

-- NUI CallBacks
RegisterNUICallback('get_config', function(data, cb)
    cb({ Settings = cfg.Settings })
end)

-- main loop when a player joins! --
Citizen.CreateThread(function()
    if NetworkIsSessionStarted() then
        if(HUD.serverId == nil) then
            HUD.serverId = GetPlayerServerId(PlayerId())
        end

        if(cfg.prioritySettings['enabled']) then
            TriggerServerEvent("rps_qbhud:UPDATEDAPRIORTY");
        end
      
        if(cfg.aopSettings['enabled']) then
            TriggerServerEvent("HUD:UPDATEDUMBAOP")
        end
      
        if(cfg.peacetimeSettings['enabled']) then
            TriggerServerEvent("rps_qbhud:UPDATEDUMBPEACETIME")
        end
    end
end)


-- Events
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    ped = PlayerPedId()
    -- playerid = PlayerId()
    -- xPlayerId = GetPlayerServerId(source)
    CreateThread(function()
        Wait(5000)
        SetEntityMaxHealth(ped, 200)
        SetEntityHealth(ped, 200)
        SetPlayerHealthRechargeMultiplier(player, 0.0)
        SetPlayerHealthRechargeLimit(player, 0.0)
    end)
    CreateThread(function()
        Wait(1000)
        QBCore.Functions.GetPlayerData(function(PlayerData)
            PlayerJob = PlayerData.job
            jobrank = PlayerData.job.grade.name
            jobname = PlayerData.job.name:upper()
            onDuty = PlayerData.job.onduty
            citizenid = PlayerData.citizenid
            playerCash = PlayerData.money.cash
            playerBank = PlayerData.money.bank
            SetPedArmour(ped, PlayerData.metadata["armor"])
            if (not PlayerData.metadata["inlaststand"] and PlayerData.metadata["isdead"]) then
                deathTime = Laststand.ReviveInterval
                OnDeath()
                DeathTimer()
            elseif (PlayerData.metadata["inlaststand"] and not PlayerData.metadata["isdead"]) then
                SetLaststand(true, true)
            else
                TriggerServerEvent("hospital:server:SetDeathStatus", false)
                TriggerServerEvent("hospital:server:SetLaststandStatus", false)
            end
        end)
    end)
    QBCore.Functions.TriggerCallback('smallresources:server:GetCurrentPlayers', function(result)
        ActivePlayers = result
    end)
    Wait(1000) 
    -- SendNUIMessage({
    --     action = 'showHUD',
    -- })

    SendReactMessage({
        type = 'showHUD',
        data = {}
    })


    TriggerEvent('chat:addSuggestion', '/setaop', 'Updates the Servers Current AOP.', {
        { name = 'aop', help = 'Updates AOP' }
    })

    Wait(500)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    SendReactMessage({
        type = 'hideHUD',
        data = {}
    })
    -- SendNUIMessage({
    --     action = 'hideHUD', 
    -- })
end)

RegisterNetEvent('hud:updatePlayerCount')
AddEventHandler('hud:updatePlayerCount', function()
    QBCore.Functions.TriggerCallback('smallresources:server:GetCurrentPlayers', function(result)
        -- SendNUIMessage({ action = 'updatePlayers', activePlayers = result })
        SendReactMessage({
            type = 'updatePlayers',
            data = {
                activePlayers = result
            }
        })
    end)
end)

RegisterNetEvent('hud:renderPostal')
AddEventHandler('hud:renderPostal', function(postalcode, postalrange)
    -- SendNUIMessage({ action = 'updatePostal', postalCode = postalcode, postalrange = postalrange})
    SendReactMessage({
        type = 'updatePostal',
        data = {
            postalCode = postalcode, 
            postalrange = postalrange
        }
    })
end)

RegisterNetEvent('hud:displayAOP')
AddEventHandler('hud:displayAOP', function(aop)
    CurrentAOP = aop
    -- SendNUIMessage({ action = 'updateAOP', aop = CurrentAOP})

    SendReactMessage({
        type = 'updateAOP',
        data = {
            enabed = cfg.aopSettings['enabled'],
            aop = CurrentAOP
        }
    });
    HUD.notify({ resource = cfg.Settings['notifyBy'], source = source, title = 'AOP Updated', text = 'Current AOP: '..CurrentAOP, style = 'info', sound = true})
end)

RegisterNetEvent("HUD:AOPCHANGE")
AddEventHandler("HUD:AOPCHANGE", function(aop)
    CurrentAOP = aop
end)



-- Threads
while true do 
    Citizen.Wait(50)
    playerid = PlayerId()
    xPlayerId = GetPlayerServerId(playerid)
    PlayerChar = HUD.getPlayerData()
    PlayerJob = PlayerChar.job
    jobrank = PlayerChar.job.grade.name
    jobname = PlayerChar.job.name:upper()
    playerCash = PlayerChar.money.cash
    playerBank = PlayerChar.money.bank
    streetName, crossing = HUD.getStreets()
    HUD.heading = HUD.getHeading()
    talking = NetworkIsPlayerTalking(playerid)
    isUnderwater = IsPedSwimmingUnderWater(GetPlayerPed(playerid))
    SendReactMessage({
        type = 'loadClientHUD',
        data = {
            logo = cfg.Settings['style'].logo,
            usePriority = cfg.prioritySettings['enabled'],
            playerServerId = xPlayerId,
            activePlayers = ActivePlayers,
            maxPlayers = maxPlayerSlots,
            aop = CurrentAOP,
            jobname = jobname,
            jobgrade = jobrank,
            cash = playerCash,
            bank = playerBank,
            heading = HUD.heading,
            micActive = talking,
            streets = { street = streetName, crossStreet = crossing },
            underWater = isUnderwater,
        }
    });
end

Citizen.CreateThread(function() 
    while true do
        if cfg.Settings['postals']['enabled'] then
            local playerPed = PlayerPedId()  -- Get the player's Ped (character)
            local playerCoords = GetEntityCoords(playerPed)  -- Get the coordinates of the player's Ped
            local nearest = {}

            if cfg.Settings['postals']['builtIn'] then
                nearest = exports[resourceName]:getPostalServer(playerCoords)
            else
                nearest = exports[cfg.Settings['postals']['resourceName']]:getPostalServer(playerCoords)
            end

            SendReactMessage({
                type = 'updatePostal',
                data = {
                    postalCode = nearest?.code, 
                    postalrange = nearest?.dist,
                }
            });
        end
    end
end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    local defaultAspectRatio = 1920/1080 -- Don't change this.
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX/resolutionY
    local minimapOffset = 0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio-aspectRatio)/3.6)-0.008
    end

    if not cfg.Settings['minimap']['useRoundMap'] then
        RequestStreamedTextureDict("squaremap", false)
        if not HasStreamedTextureDictLoaded("squaremap") then
            Wait(150)
        end
        if cfg.Settings['minimap']['notifications'] then
            HUD.notify({ resource = cfg.Settings['notifyBy'], source = source, id = 'map_loading', title = 'System Message', text = 'Loading Square Map', icon = 'info', iconColor = '#fff', style = 'info' })
        end
        SetMinimapClipType(0)
        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
        AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")
        -- 0.0 = nav symbol and icons left
        -- 0.1638 = nav symbol and icons stretched
        -- 0.216 = nav symbol and icons raised up
        SetMinimapComponentPosition("minimap", "L", "B", 0 + minimapOffset, -0.047, 0.1698, 0.183)

        -- icons within map
        SetMinimapComponentPosition("minimap_mask", "L", "B", 0 + minimapOffset, 0.0, 0.132, 0.20)

        -- -0.01 = map pulled left
        -- 0.025 = map raised up
        -- 0.262 = map stretched
        -- 0.315 = map shorten
        SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01 + minimapOffset, 0.025, 0.268, 0.300)
        SetBlipAlpha(GetNorthRadarBlip(), 0)
        SetRadarBigmapEnabled(true, false)
        SetMinimapClipType(0)
        Wait(50)
        SetRadarBigmapEnabled(false, false)
        if cfg.Settings['minimap']['mapBoarders'] then
            showCircleB = false
            showSquareB = true
        end
        Wait(1200)
        if cfg.Settings['minimap']['notifications'] then
            HUD.notify({ resource = cfg.Settings['notifyBy'], source = source, id = 'map_loading', title = 'System Message', text = 'Loaded Square Map', icon = 'info', iconColor = '#fff', style = 'info' })
        end
    else
        RequestStreamedTextureDict("circlemap", false)
        if not HasStreamedTextureDictLoaded("circlemap") then
            Wait(150)
        end
        if cfg.Settings['minimap']['notifications'] then
            HUD.notify({ resource = cfg.Settings['notifyBy'], source = source, id = 'map_loading', title = 'System Message', text = 'Loading Round Map', icon = 'info', iconColor = '#fff', style = 'info' })
        end
        SetMinimapClipType(1)
        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
        AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "circlemap", "radarmasksm")
        -- -0.0100 = nav symbol and icons left
        -- 0.180 = nav symbol and icons stretched
        -- 0.258 = nav symbol and icons raised up
        SetMinimapComponentPosition("minimap", "L", "B", -0.0100 + minimapOffset, -0.030, 0.180, 0.258)

        -- icons within map
        SetMinimapComponentPosition("minimap_mask", "L", "B", 0.200 + minimapOffset, 0.0, 0.065, 0.20)

        -- -0.00 = map pulled left
        -- 0.015 = map raised up
        -- 0.252 = map stretched
        -- 0.338 = map shorten
        SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.00 + minimapOffset, 0.015, 0.252, 0.338)
        SetBlipAlpha(GetNorthRadarBlip(), 0)
        SetMinimapClipType(1)
        SetRadarBigmapEnabled(true, false)
        Wait(50)
        SetRadarBigmapEnabled(false, false)
        if cfg.Settings['minimap']['mapBoarders'] then
            showCircleB = true
            showSquareB = false
        end
        Wait(1200)
        if cfg.Settings['minimap']['notifications'] then
            HUD.notify({ resource = cfg.Settings['notifyBy'], source = source, id = 'map_loading', title = 'System Message', text = 'Loaded Round Map', icon = 'info', iconColor = '#fff', style = 'info' })
        end
    end

    while true do
        Wait(0)
        SetRadarZoom(1000)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        -- SetMinimapOverlayDisplay(minimap, 100, 50, 550, 400, 100);
        -- SetMinimapComponentPosition(minimap, 100, 100, 100, 100, 100, 100)
        -- SetMinimapOverlayDisplay(1, 100, 50, 550, 400, 0);
    end
end)