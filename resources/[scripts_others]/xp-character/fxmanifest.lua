shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'bodacious'
game 'gta5'

ui_page 'character-nui/index.html'

files {
	'character-nui/index.html',
	'character-nui/range.png',
	'character-nui/style.css',
	'character-nui/vue.js'
}

client_scripts {
	'@vrp/lib/utils.lua',
	'client.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	"@vrp/cfg/webhook.lua",
	'server.lua'
}              

files {
	"character-nui/**/**/*",
	"character-nui/**/*",
	"character-nui/*",
}