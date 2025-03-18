-- config.lua
cfg = {}

cfg.licenseKey = "" -- License Key goes here 

cfg.Settings = {
    ['debug'] = true, -- Enable debug mode. This prints debug messages to the client/server console if true.
    
    ['maxPlayers'] = GetConvarInt('sv_maxclients', 32),
    ['VoiceCycleKey'] = GetConvar('voice_defaultCycle', 'F11'),
    ['postalDisplay'] = true, -- This will enable postals display next to the street name.
    ['style'] = {
        logo = 'https://cdn.crypticoffical.net/u/deathsoulytscloud/f5mUiRb1CT.png',
        colors = {
            primary = '#db15bc',
            secondary = '#04ffed',
            background = '#19153fcc',
        }
    },

    ['minimap'] = {
        ['useRoundMap'] = false,
        ['notifications'] = true,
        ['mapBorders'] = true, -- if true, this will add a bordered outline around the map.
        ['hideMapOnFoot'] = true, -- if true, the map will be hidden once you're on foot.
    },
}

-- AOP SCRIPT-- 
cfg.aopSettings = {
    ['enabled'] = true,
    ['defaultAOP'] = 'State Wide',
}

-- priority SCRIPT -- 
cfg.prioritySettings = {
    ['enabled'] = false,
    ['time'] = {
        maxTime = 45,
        defaultTime = 20, 
    }
}

-- PEACETIME -- 
cfg.peacetimeSettings = {
    ['enabled'] = false,
}