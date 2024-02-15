fx_version 'cerulean'
games { 'gta5' }

author 'Shreider_404'
version '1.0.0'

server_scripts {
    'server.lua',

    '@mysql-async/lib/MySQL.lua'
}

client_scripts {
    'client.lua'
}

dependencies {
    'mysql-async'
}