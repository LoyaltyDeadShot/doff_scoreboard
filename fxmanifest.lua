fx_version 'adamant'

game 'gta5'

author 'DoFF'
description 'DoFF Scoreboard for ESX Legacy'
lua54 'yes'
version '0.0.0'

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/jquery/jquery-3.6.1.min.js',
	'html/jquery/jquery-ui.min.js',
	'html/js/script.js',
	'html/css/style.css',
}

dependency 'es_extended'