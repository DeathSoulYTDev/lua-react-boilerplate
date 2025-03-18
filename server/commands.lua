RegisterNetEvent("rps_qbhud:RegisterSVCommands")
AddEventHandler("rps_qbhud:RegisterSVCommands", function(licenseActive)
    if licenseActive then
        TriggerEvent('rps_qbhud:debugPrint', 'debug', '^2License Activated!')
        TriggerEvent('rps_qbhud:debugPrint', 'debug', '^4Registering Commands..')
        -- print('License Activated! Registering Commands..')
        if(Config.aopSettings['enabled']) then
            RegisterCommand('setaop', function(source, args)
                if IsPlayerAceAllowed(source, 'hud.setaop') then
                    if (string.len(table.concat(args, " ")) > 0) then
                        local CurrentAOP = table.concat(args, " ")
                        HUD.setAop(table.concat(args, " "))
                        TriggerClientEvent('HUD:AOPCHANGE', -1, table.concat(args, " "))
                    end
                else
                    TriggerClientEvent('cnotify:notify', source, 'System Alert', 'You Are Not Authorized for this Command', 5000, 'error', true)
                end
            end)
        end
        
        -- if(Config.prioritySettings['enabled']) then
            
        -- end
    
        -- if(Config.peacetimeSettings['enabled']) then
        
        
        -- end
    else
        TriggerEvent('rps_qbhud:debugPrint', 'debug', '^1License Has Not Been Activated! Try Again Later..'')
    end
end)