-- optimizations
local ipairs = ipairs
local upper = string.upper
local format = string.format
-- end optimizations

---
--- [[ Nearest Postal Commands ]] ---
---

RegisterNetEvent('postalNotify')
AddEventHandler('postalNotify', function(source, data)
    if cfg.Settings['postals']['notifyBy'] == 'chat' then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            args = {
                'Postals',
                data.text
            }
        })
    else
        HUD.notify({ resource = cfg.Settings['notifyBy'], source = source, id = data.id, title = data.title, text = data.text, icon = data.icon, iconColor = data.iconColor })
    -- elseif cfg.Settings['postals']['notifyBy'] == 'qb' then
    --     return
    end
end)

TriggerEvent('chat:addSuggestion', '/'..cfg.Settings['postals']['command'], 'Set the GPS to a specific postal',
             { { name = 'Postal Code', help = 'The postal code you would like to go to' } })

RegisterCommand(cfg.Settings['postals']['command'], function(_, args)
    if #args < 1 then
        if pBlip then
            RemoveBlip(pBlip.hndl)
            pBlip = nil

            TriggerEvent('postalNotify', _, { id = 'route_deleted', title = 'Route Removed', text = cfg.Settings['postals']['blip']['deleteText'], icon = 'trash', iconColor = '#C53030'})
        end
        return
    end

    local userPostal = upper(args[1])
    local foundPostal

    for _, p in ipairs(postals) do
        if upper(p.code) == userPostal then
            foundPostal = p
            break
        end
    end

    if foundPostal then
        if pBlip then RemoveBlip(pBlip.hndl) end
        local blip = AddBlipForCoord(foundPostal[1][1], foundPostal[1][2], 0.0)
        pBlip = { hndl = blip, p = foundPostal }
        SetBlipRoute(blip, true)
        SetBlipSprite(blip, cfg.Settings['postals']['blip']['sprite'])
        SetBlipColour(blip, cfg.Settings['postals']['blip']['color'])
        SetBlipRouteColour(blip, cfg.Settings['postals']['blip']['color'])
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(format(cfg.Settings['postals']['blip']['blipText'], pBlip.p.code))
        EndTextCommandSetBlipName(blip)

        TriggerEvent('postalNotify', _, { id = 'new_route', title = 'Route Set', text = format(cfg.Settings['postals']['blip']['drawRouteText'], foundPostal.code), icon = 'check', iconColor = '#C53030'})
        -- TriggerEvent('chat:addMessage', {
        --     color = { 255, 0, 0 },
        --     args = {
        --         'Postals',
        --         format(cfg.Settings['postals']['blip']['drawRouteText'], foundPostal.code)
        --     }
        -- })


    else
        TriggerEvent('postalNotify', { id = 'invalid_postal', title = 'Invalid Postal', text = cfg.Settings['postals']['blip']['notExistText'], icon = 'ban', iconColor = '#C53030'})
    end
end)
