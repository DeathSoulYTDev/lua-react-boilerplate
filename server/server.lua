QBCore = exports["qb-core"]:GetCoreObject()
local Settings = Config.Settings
local creatormode = Tags.creatormode
local license = Config.licenseKey
local Debug = Config.Settings['debug']
local authStatus = 'pending'
PriorityState = "InActive"

HUD = {}

HUD.licenseActive = false;
HUD.AOP = {enabled = Config.aopSettings['enabled'], aop = Config.aopSettings['defaultAOP']};
HUD.peacetime = {enabled = Config.peacetimeSettings['enabled'], peacetime = false};
HUD.priority = {enabled = Config.prioritySettings['enabled'], currentName = "", maxTime = Config.prioritySettings['time'].maxTime, defaultTime = Config.prioritySettings['time'].defaultTime, hold = false, start = false}

-- Events
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end

    if creatormode == true then
        DebugPrint('creator', nil)
        if Tags.versionCheck == false then
            print('Version Check Disabled')
        else
            TriggerEvent('rps_qbhud:versionCheck')
        end
        HUD.licenseActive = true
        TriggerEvent('rps_qbhud:RegisterSVCommands', HUD.licenseActive)
    else
        ValidateLicense()
    end
end)

AddEventHandler('playerJoining', function()
    TriggerClientEvent('updatePlayerCount')
end)

AddEventHandler('playerDropped', function()
    TriggerClientEvent('updatePlayerCount')
end)

RegisterNetEvent("HUD:UPDATEDUMBAOP")
AddEventHandler("HUD:UPDATEDUMBAOP", function()
  local src = source;

  TriggerClientEvent('HUD:AOPCHANGE', src, HUD.getAop())
end)
-- Functions


-- License Checking Function Code Below
function ValidateLicense()
    if license ~= nil and license ~= 'undefined' and license ~= '' then
        PerformHttpRequest('https://store.crypticoffical.net/api/v1/license/check/' .. license, function(errorCode, resultData, resultHeaders)
            local data = json.decode(resultData)
            Wait(500)
            if data['authorized'] then   
                authStatus = '^4License Authorization ^2Successfull^7!' 
                DebugPrint('licensecheck', authStatus)
                if not Tags.versionCheck then
                    print('Version Check Disabled')
                else
                    TriggerEvent('rps_qbhud:versionCheck')
                end
                HUD.licenseActive = true
                TriggerEvent('rps_qbhud:RegisterSVCommands', HUD.licenseActive)
                -- LoadController()
            else
                HUD.licenseActive = false
                authStatus = '^4License Authorization ^1Failed!^7'  
                DebugPrint('licensecheck', authStatus)
                Wait(5000)
                TriggerEvent('rps_qbhud:RegisterSVCommands', HUD.licenseActive)
                if Tags.noKeyCrash ~= false then
                    os.exit(0)
                else
                    return
                end
            end
        end, 'GET', '', {
            ['Accept'] = 'application/json, text/plain, */*',
            ['User-Agent'] = '*',
            ['productid'] = Tags.productid
        });
    else
        authStatus = '^1Failed to Load License Key!^7'  
        DebugPrint('licensecheck', authStatus)
        if Tags.noKeyCrash ~= false then
            os.exit(0)      
        end
    end
end

RegisterNetEvent('rps_qbhud:debugPrint', function(tag, content)
    DebugPrint(tag, content)
end)

function DebugPrint(tag, content)
    if (GetCurrentResourceName() == "rps_qbhud") then
        local debugStatus
        if Debug then 
            debugStatus = '^2Active'
        else
            debugStatus = '^1Inactive'
        end

        if tag == "developer" then
            print('^9[^1CN^4HUD^9] Created By: ^5DeathSoulYT ^4https://discord.gg/QBZQehkBwc^7')
        elseif tag == "creator" then
            print('^4Creator Mode is ^2Active ^4Skipping License Check...^7')
        elseif tag == 'licensecheck' then
            print('^9[^1CN^4HUD^9] ^3'..content..'^7')            
        elseif tag == 'debug' then
            print('^9[^1CN^4HUD^9] ^7Debug: '..content..'^7')
        elseif tag == nil then
            if Debug then
                print('^9[^1CN^4HUD^9] ^7'..content)
            end
        end
    end
end


-- HUD Functions
HUD.getAop = function()
    return HUD.AOP.aop
end

HUD.setAop = function(aop)
    HUD.AOP.aop = aop
    print(aop)
end

HUD.getPeacetime = function()
    if(HUD.peacetime.enabled) then
      return HUD.peacetime.peacetime
    else
      return nil 
    end
end
  
HUD.setPeacetime = function(value)
    local peacetime = HUD.getPeacetime()
    HUD.peacetime.peacetime = value
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