QBCore = exports["qb-core"]:GetCoreObject()
local Settings = cfg.Settings
local creatormode = Tags.creatormode
local license = cfg.licenseKey
local Debug = cfg.Settings['debug']
local authStatus = 'pending'
PriorityState = "InActive"

local expectedResourceName = "rps_qbhud"

-- Get the current resource name (i.e. the folder name)
local currentResourceName = GetCurrentResourceName()

HUD = {}

HUD.licenseActive = false;
HUD.AOP = {enabled = cfg.aopSettings['enabled'], aop = cfg.aopSettings['defaultAOP']};
HUD.peacetime = {enabled = cfg.peacetimeSettings['enabled'], peacetime = false};
HUD.priority = {enabled = cfg.prioritySettings['enabled'], currentName = "", maxTime = cfg.prioritySettings['time'].maxTime, defaultTime = cfg.prioritySettings['time'].defaultTime, hold = false, start = false}

-- Events
AddEventHandler('onResourceStart', function(resourceName)
    if currentResourceName == expectedResourceName and resourceName ~= expectedResourceName then
        Wait(500)
        DebugPrint(nil, "^1Error: Don't rename the resource!^7")
        return
    end

    if not Config then
        DebugPrint(nil, "^1Error: Config table is missing!^7")
        return
    end

    if not Tags then
        DebugPrint(nil, "^1Error: Tags table is missing!^7")
        return
    end

    if Tags and cfg and GetCurrentResourceName() == expectedResourceName then
        Wait(500)
        DebugPrint(nil, '^7----------------- ^2Starting ^7-----------------')
    end

    if Tags.creatormode or Flags.skipLicense then
        DebugPrint(nil, '^7---------- ^4Skipping ^2License Check ^7----------')
        if Tags.creatormode then
            DebugPrint('creator', nil)
        end
        TriggerEvent('rps_qbhud:versionCheck')
        HUD.licenseActive = true
    else
        Wait(1000)
        DebugPrint(nil, '^7---------- ^4Checking ^2License ^7----------')
        Wait(500)
        ValidateLicense()

        
        if Tags and Tags.LicenseCheckTime then
            CreateThread(function()
                Wait(60000 * Tags.LicenseCheckTime)
                while true do
                    DebugPrint(nil, '^7---------- ^4Checking ^2License ^7----------')
                    local err, massage = pcall(RevalidateLicense(), true)
                    if err then
                        DebugPrint(nil, 'Failed to check License')
                        DebugPrint(nil, '^1Error ' .. massage .. '^7')
                        DebugPrint(nil, '^7--------------------------------------')
                        return;
                    end
                    Wait(60000 * Tags.LicenseCheckTime)
                end
            end)
        else
            DebugPrint(nil, "^1Error: LicenseCheckTime not set in Tags^7")
        end
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
        PerformHttpRequest(Tags.StoreLink .. Tags.StoreAPIRoute .. 'license/check/' .. license,
            function(errorCode, resultData, resultHeaders)
                if Config.debug then
                    DebugPrint(nil, 'License Http Response: ^1' .. resultData)
                end
                local data = json.decode(resultData)

                Wait(500)
                if data['authorized'] then
                    authStatus = '^4License Authorization ^2Successfull^7!'
                    DebugPrint('licensecheck', authStatus)
                    DebugPrint(nil, '^7--------------------------------------')
                    Wait(500)
                    TriggerEvent('rps_qbhud:versionCheck', nil)
                else
                    HUD.licenseActive = false
                    authStatus = '^4License Authorization ^1Failed!^7'  
                    DebugPrint('licensecheck', authStatus)
                    Wait(5000)
                    TriggerEvent('rps_qbhud:RegisterSVCommands', HUD.licenseActive)
                    if Tags.noKeyCrash ~= false then
                        DebugPrint(nil, '^1Shutting down resource!^7')
                        -- DebugPrint(nil, "^1Critical Error: Shutting down resource!^7")
                        DebugPrint(nil, '^7--------------------------------------')
                        -- Wait(5000)
                        os.exit(0)
                    else
                        DebugPrint(nil, '^7--------------------------------------')
                        return true
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
            DebugPrint(nil, "^1Critical Error: Shutting down resource!^7")
            os.exit(0)
        end
    end
end

function RevalidateLicense()
    if Config.licenseKey ~= nil and Config.licenseKey ~= 'undefined' and Config.licenseKey ~= '' then
        PerformHttpRequest(Tags.StoreLink .. Tags.StoreAPIRoute .. '/license/check/' .. Config.licenseKey,
            function(errorCode, resultData, resultHeaders)
                if Config.debug then
                    DebugPrint(nil, 'License Http Response: ^1' .. resultData)
                end
                local data = json.decode(resultData)
                -- if not data then
                --     DebugPrint(nil, "^1Error: Invalid JSON response from license server^7")
                --     return
                -- end
                Wait(500)
                if data['authorized'] then
                    authStatus = '^4License Authorization ^2Successfull^7!'
                    DebugPrint('licensecheck', authStatus)
                    DebugPrint(nil, '^7--------------------------------------')
                else
                    authStatus = '^4License Authorization ^1Failed!^7'
                    DebugPrint('licensecheck', authStatus)
                    DebugPrint(nil, '^1Shutting Down')
                    DebugPrint(nil, '^7--------------------------------------')
                    Wait(500)
                    if Tags.noKeyCrash ~= false then
                        DebugPrint(nil, "^1Critical Error: Shutting down resource!^7")
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
        if nokeycrash ~= false then
            return os.exit(0)
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
            print('^9[^1CN^4HUD^9] ^7Debug: '..debugStatus..'^7')
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