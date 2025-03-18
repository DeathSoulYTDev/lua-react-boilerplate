RegisterNetEvent('rps_qbhud:versionCheck', function()
    PerformHttpRequest('https://store.crypticoffical.net/changelog/' ..Tags.productid.. '/latest_version', function(errorCode, resultData, resultHeaders)
        if not resultData then print('Failed to check for updates') return end
        local result = json.decode(resultData)
        if GetResourceMetadata(GetCurrentResourceName(), 'version', 0) < result['version'] then
            TriggerEvent('rps_qbhud:debugPrint', nil, '^2New version of '..GetCurrentResourceName()..' is available')
            TriggerEvent('rps_qbhud:debugPrint', nil, '^4Running Version: '..GetResourceMetadata(GetCurrentResourceName(), 'version', 0))
            TriggerEvent('rps_qbhud:debugPrint', nil, '^3Latest Release: '..result['version'])
            TriggerEvent('rps_qbhud:debugPrint', nil, '^1Please Update ASAP to Receive support!')
            TriggerEvent('rps_qbhud:debugPrint', 'developer', nil)
        elseif GetResourceMetadata(GetCurrentResourceName(), 'version', 0) == result['version'] then
            TriggerEvent('rps_qbhud:debugPrint', nil, '^4Running Version: '..GetResourceMetadata(GetCurrentResourceName(), 'version', 0))
            TriggerEvent('rps_qbhud:debugPrint', nil, '^3Latest Release: '..result['version'])
            TriggerEvent('rps_qbhud:debugPrint', nil, '^2Currently Running the Release version of '..GetCurrentResourceName())
            TriggerEvent('rps_qbhud:debugPrint', 'developer', nil)
        elseif GetResourceMetadata(GetCurrentResourceName(), 'version', 0) > result['version'] then
            TriggerEvent('rps_qbhud:debugPrint', nil, '^4Running Version: '..GetResourceMetadata(GetCurrentResourceName(), 'version', 0))
            TriggerEvent('rps_qbhud:debugPrint', nil, '^3Latest Release: '..result['version'])
            TriggerEvent('rps_qbhud:debugPrint', nil, '^2Currently Running a Development version of '..GetCurrentResourceName())
            TriggerEvent('rps_qbhud:debugPrint', 'developer', nil)
        end
    end)
end) 