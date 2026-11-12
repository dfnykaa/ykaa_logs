fx_version 'cerulean'
game 'gta5'

author 'ykaa'
description 'Discord logging System'
version '3.0.0'

lua54 'yes'

client_scripts {
    'client/logs.lua'
}

server_scripts {
    'config/locale.lua',
    'config/config.lua',
    'server/logs.lua',
    'server/version.lua'
}
