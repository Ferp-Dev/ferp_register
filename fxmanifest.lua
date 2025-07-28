fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'Cashier System'
version '1.0.0'
author 'Ferp.Dev'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/locales.lua',
    'locales/*.lua',
    'shared/framework.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

dependencies {
    'ox_lib',
    'ox_target'
}

export 'processCashierPayment'
export 'cancelPayment'
export 'getActivePayments'
export 'registerCharge'
export 'getActiveCharges'
export 'clearCharge'