fx_version "cerulean"
lua54 "yes"
games {"gta5"}

author 'DeathSoulYT'
description 'RPS HUD'
version '1.0.0'
use_fxv2_oal 'yes'

ui_page "build/index.html"
lua54 "yes"

shared_scripts {
  'shared/*.lua',
  -- "@oxmysql/lib/MySQL.lua"
  "@ox_lib/init.lua" -- uncomment if you are using ox_lib
}
-- server_script {
--   "server/server.lua",
--   "@oxmysql/lib/MySQL.lua"
-- }

server_scripts {
	'server/server.lua',
	'server/version.lua',
	'server/commands.lua',
  "@oxmysql/lib/MySQL.lua"
}

client_scripts {
	'client/cl_main.lua',
	'client/functions.lua',
	'@PolyZone/client.lua',
	'@PolyZone/CircleZone.lua',
  "client/utils.lua"
}

-- client_script {
--   "client/client.lua",
--   "client/utils.lua"
-- }

files {
  "build/index.html",
  "build/**/*"
}
