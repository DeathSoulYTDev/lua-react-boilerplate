-- config.lua
cfg = {}

cfg.licenseKey = "" -- License Key goes here 

cfg.Settings = {
    ['debug'] = true, -- Enable debug mode. This prints debug messages to the client/server console if true.
    
    ['maxPlayers'] = GetConvarInt('sv_maxclients', 32),
    ['VoiceCycleKey'] = GetConvar('voice_defaultCycle', 'F11'),
    -- ['postalDisplay'] = true, -- This will enable postals display next to the street name.
    ['postals'] = {
        -- Support Notification Methods
        -- [ChatMessage: chat, OX_LIB Notifications: ox, QBNotify: qb, Cryptic Notify: cn, MORE COMING SOON!..], 
        ['notifyBy'] = 'ox',
        -- This will enable postals display on the hud 
        -- showsing your nearest postal next to the street name.
        ['enabled'] = true, 
        -- the name of the nearest postal resource you use
        ['resourceName'] = 'nearest-postal',
        -- this will enable and use the built in
        -- nearest postal system in the hud resource
        -- disable to use your own resource
        -- add its name above replace the nearest-postal
        -- text with your resource name
        ['builtIn'] = true,
        -- the prefix name of the postals json file
        -- e.g: so for OCRP postals you would change custom to say ocrp
        -- and make sure the file name constains the filePrefix and "-postals.json" after it
        ['filePrefix'] = 'custom', 
        -- the command to use when settings a gps route to a postal [DONT add a slash]
        ['command'] = 'postal',
        -- How often in milliseconds the postal code is updated on each client.
        -- I wouldn't recommend anything lower than 50ms for performance reasons
        ['updateDelay'] = nil,
        ['blip'] = {
            -- The text to display in chat when setting a new route. 
            -- Formatted using Lua strings, http://www.lua.org/pil/20.html
            ['blipText'] = 'Postal Route %s',
            -- The sprite ID to display, the list is available here:
            -- https://docs.fivem.net/docs/game-references/blips/#blips
            ['sprite'] = 8,
            -- The color ID to use (default is 3, light blue)
            -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
            ['color'] = 3
            -- When the player is this close (in meters) to the destination, 
            -- the blip will be removed.
            ['distToDelete'] = 100.0,
            -- The text to display in chat when a route is deleted
            ['deleteText'] = 'Route deleted',
            -- The text to display in chat when drawing a new route
            ['drawRouteText'] = 'Drawing a route to %s',
            -- The text to display when a postal is not found.
            ['notExistText'] = "That postal doesn't exist",
        },
        ['text'] = {
            -- The text to display on-screen for the nearest postal. 
            -- Formatted using Lua strings, http://www.lua.org/pil/20.html
            ['format'] = '~y~Nearest Postal~w~: %s (~g~%.2fm~w~)',
            ['arrivedAtDest'] = "You've reached your postal destination!"
        },
    },
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