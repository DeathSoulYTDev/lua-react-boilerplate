-- optimizations
local ipairs = ipairs
local upper = string.upper
local format = string.format
-- end optimizations

---
--- [[ Nearest Postal Commands ]] ---
---

TriggerEvent('chat:addSuggestion', '/'..cfg.Settings['postals']['command'], 'Set the GPS to a specific postal',
             { { name = 'Postal Code', help = 'The postal code you would like to go to' } })

RegisterCommand(cfg.Settings['postals']['command'], function(_, args)
    if #args < 1 then
        if pBlip then
            RemoveBlip(pBlip.hndl)
            pBlip = nil
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0 },
                args = {
                    'Postals',
                    cfg.Settings['postals']['blip']['deleteText']
                }
            })
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

        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            args = {
                'Postals',
                format(cfg.Settings['postals']['blip']['drawRouteText'], foundPostal.code)
            }
        })
    else
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            args = {
                'Postals',
                cfg.Settings['postals']['blip']['notExistText']
            }
        })
    end
end)
