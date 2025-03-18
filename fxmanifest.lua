-- the postal map to read from
-- change it to whatever model you want that is in this directory
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
  "@ox_lib/init.lua" -- uncomment if you are using ox_lib
}

server_scripts {
  'server/*.lua',
	-- 'server/server.lua',
	-- 'server/version.lua',
	-- 'server/commands.lua',
  "@oxmysql/lib/MySQL.lua",
}

client_scripts {
	'client/cl_main.lua',
	'client/functions.lua',
  "client/utils.lua",
	'@PolyZone/client.lua',
	'@PolyZone/CircleZone.lua',
  'cl_postals/*.lua',
}

files {
  "build/index.html",
  "build/**/*",
  "postalFiles/*",
}

server_exports {
  'getPostalServer',
}
