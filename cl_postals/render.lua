-- optimizations
local vec = vec
local Wait = Citizen.Wait
local format = string.format
local RemoveBlip = RemoveBlip
local PlayerPedId = PlayerPedId
local IsHudHidden = IsHudHidden
local SetTextFont = SetTextFont
local SetTextScale = SetTextScale
local SetTextOutline = SetTextOutline
local GetEntityCoords = GetEntityCoords
local EndTextCommandDisplayText = EndTextCommandDisplayText
local BeginTextCommandDisplayText = BeginTextCommandDisplayText
local AddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName
-- end optimizations

local nearestPostalText = ""

-- recalculate current postal
Citizen.CreateThread(function()
    -- wait for postals to load
    while postals == nil do Wait(1) end

    local delay = math.max(cfg.Settings['postals']['updateDelay'] and tonumber(cfg.Settings['postals']['updateDelay']) or 300, 50)
    if not delay or tonumber(delay) <= 0 then
        error("Invalid render delay provided, it must be a number > 0")
    end

    local postals = postals
    local deleteDist = cfg.Settings['postals']['blip']['distToDelete']
    local formatTemplate = cfg.Settings['postals']['text']['format']
    local _total = #postals

    while true do
        local coords = GetEntityCoords(PlayerPedId())
        local _nearestIndex, _nearestD
        coords = vec(coords[1], coords[2])

        for i = 1, _total do
            local D = #(coords - postals[i][1])
            if not _nearestD or D < _nearestD then
                _nearestIndex = i
                _nearestD = D
            end
        end

        if pBlip and #(pBlip.p[1] - coords) < deleteDist then
            TriggerEvent('postalNotify', { id = 'arrv_dest', title = 'Destination', text = cfg.Settings['postals']['text']['arrivedAtDest'], icon = 'map-location', iconColor = '#C53030'})
            -- TriggerEvent('chat:addMessage', {
            --     color = { 255, 0, 0 },
            --     args = {
            --         'Postals',
            --         cfg.Settings['postals']['text']['arrivedAtDest']
            --     }
            -- })
            RemoveBlip(pBlip.hndl)
            pBlip = nil
        end

        local _code = postals[_nearestIndex].code
        nearest = { code = _code, dist = _nearestD }
        nearestPostalText = format(formatTemplate, _code, _nearestD)
        Wait(delay)
    end
end)