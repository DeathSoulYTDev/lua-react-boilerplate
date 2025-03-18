function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do        
        Citizen.Wait(100)
    end
end

HUD.freeze = function()
    local ped = GetPlayerPed(-1)
    DisplayHud(false)
    DisplayRadar(false)
    SetNuiFocus(true, true)
    SetPlayerInvincible(PlayerId(), true)
    if IsEntityVisible(ped) then
      SetEntityVisible(ped, false)
    end
    FreezeEntityPosition(ped, true)
end

HUD.disablePeacetimeKeybinds = function()
    local ped = GetPlayerPed(-1)
    SetPlayerCanDoDriveBy(ped, false)
    DisablePlayerFiring(ped, true)
    DisableControlAction(0, 140)
    DisableControlAction(0, 37)
end

HUD.convertGTAColorToCss = function(color)
    local mainString = color
    mainString = string.gsub(mainString, "~r~", "<span style='color:red'>")
    mainString = string.gsub(mainString, "~b~", "<span style='color:blue'>")
    mainString = string.gsub(mainString, "~g~", "<span style='color:green'>")
    mainString = string.gsub(mainString, "~y~", "<span style='color:yellow'>")
    mainString = string.gsub(mainString, "~p~", "<span style='color:purple'>")
    mainString = string.gsub(mainString, "~c~", "<span style='color:grey'>")
    mainString = string.gsub(mainString, "~m~", "<span style='color:darkgrey'>")
    mainString = string.gsub(mainString, "~u~", "<span style='color:black'>")
    mainString = string.gsub(mainString, "~o~", "<span style='color:orange'>")
    mainString = string.gsub(mainString, "~w~", '<span style="color:white">')
    return mainString
end

HUD.getHeading = function()
    local heading = GetEntityHeading(PlayerPedId());

    local directions = {N = 360, 0, NE = 315, E = 270, SE = 225, S = 180, SW = 135, W = 90, NW = 45}
    for k, v in pairs(directions) do
        if (math.abs(heading - v) < 22.5) then
          heading = k;
          if (heading == 1) then
            heading = 'N';
            break;
          end
  
          break;
        end
    end
    return heading;
end

HUD.getStreets = function()
    local coords = GetEntityCoords(PlayerPedId());
    local streetName, crossing = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetName)
    local crossing = GetStreetNameFromHashKey(crossing)

    return streetName, crossing;
end

HUD.getCurStreet = function()
    local coords = GetEntityCoords(PlayerPedId());
    local streetName, crossing = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetName)
    local crossing = GetStreetNameFromHashKey(crossing)

    return streetName;
end

HUD.getCrossingStreet = function()
    local coords = GetEntityCoords(PlayerPedId());
    local streetName, crossing = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetName)
    local crossing = GetStreetNameFromHashKey(crossing)

    return crossing;
end

HUD.getPlayerData = function()
    local PlayerChar = {}
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerChar = PlayerData
    end)
    return PlayerChar;
end

