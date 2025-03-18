local insert = table.insert
local remove = table.remove

--- [[ Development shit ]]

local devLocal = {}
local next = 0

RegisterCommand('setnext', function(_, args)
    local n = tonumber(args[1])
    if n ~= nil then
        next = n
        -- print('next ' .. next)
        TriggerServerEvent('rps_qbhud:debugPrint', nil, 'next '.. next)
        return
    end
    -- print('invalid ' .. n)
    TriggerServerEvent('rps_qbhud:debugPrint', nil, 'invalid '.. n)
end)

RegisterCommand('next', function()
    for _, d in ipairs(devLocal) do
        if d.code == tostring(next) then
            -- print('duplicate ' .. next)
            TriggerServerEvent('rps_qbhud:debugPrint', nil, 'duplicate '.. next)
            return
        end
    end
    local coords = GetEntityCoords(PlayerPedId())
    insert(devLocal, { code = tostring(next), x = coords.x, y = coords.y })
    -- print('insert ' .. next)
    TriggerServerEvent('rps_qbhud:debugPrint', nil, 'insert '.. next)
    next = next + 1
end)

RegisterCommand('rl', function()
    if #devLocal > 0 then
        local data = remove(devLocal, #devLocal)
        -- print('remove ' .. data.code)
        TriggerServerEvent('rps_qbhud:debugPrint', nil, 'remove '.. data.code)
        TriggerServerEvent('rps_qbhud:debugPrint', nil, 'next '.. next)
        -- print('next ' .. next)
        next = next - 1
    else
        -- print('invalid')
        TriggerServerEvent('rps_qbhud:debugPrint', nil, 'Invalid Args')
    end
end)

RegisterCommand('remove', function(_, args)
    if #args < 1 then
        -- print('invalid')
        TriggerServerEvent('rps_qbhud:debugPrint', nil, 'invalid Args')
    else
        for i, d in ipairs(devLocal) do
            if d.code == args[1] then
                remove(devLocal, i)
                -- print('remove ' .. d.code)
                TriggerServerEvent('rps_qbhud:debugPrint', nil, 'remove '.. d.code)
                return
            end
        end
        TriggerServerEvent('rps_qbhud:debugPrint', nil, 'invalid Args')
        -- print('invalid')
    end
end)

RegisterCommand('json', function()
    TriggerServerEvent('rps_qbhud:debugPrint', nil, json.encode(devLocal))
    -- print(json.encode(devLocal))
end)