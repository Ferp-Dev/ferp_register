Config = {}

Config.Framework = 'qbx_core' -- 'qb-core' ou 'qbx_core'

Config.Commission = {
    enabled = true, 
    percentage = 5.0 
}

Config.Locale = 'en' -- 'en', 'pt-br'

Config.Companies = {
    ['burgershot'] = {
        name = 'Burger Shot',
        account = 'burgershot',
        job = 'burgershot',
        cashiers = {
            {
                coords = vector3(-1187.56, -893.58, 13.8),
                radius = 0.25,
            },
            {
                coords = vector3(-1189.09, -894.63, 13.8),
                radius = 0.25,
            },
            {
                coords = vector3(-1190.63, -895.65, 13.8),
                radius = 0.25,
            },
            {
                coords = vector3(-1194.92, -907.73, 13.77),
                radius = 0.25,
            },
        }
    },
    ['uwucafe'] = {
        name = 'UwU Cafe',
        account = 'uwucafe',
        job = 'uwucafe',
        cashiers = {
            {
                coords = vector3(-584.08, -1058.72, 22.34),
                radius = 0.25,
            },
            {
                coords = vector3(-584.02, -1061.48, 22.34),
                radius = 0.25,
            },
        }
    },
    ['maldinis'] = {
        name = 'Maldinis Pizza',
        account = 'maldinis',
        job = 'maldinis',
        cashiers = {
            {
                coords = vector3(-580.08, -886.61, 25.72),
                radius = 0.25,
            },
        }
    },
    ['rooster'] = {
        name = 'Rooster Rest',
        account = 'rooster',
        job = 'rooster',
        cashiers = {
            {
                coords = vector3(-171.01, 304.21, 98.52),
                radius = 0.25,
            },
            {
                coords = vector3(-171.05, 300.79, 98.52),
                radius = 0.25,
            },
        }
    },
    ['pizzathis'] = {
        name = 'Pizza This',
        account = 'pizzathis', 
        job = 'pizzathis',
        cashiers = {
            {
                coords = vector3(809.23, -750.32, 26.78),
                radius = 0.25,
            },
        }
    },
    ['unicorn'] = {
        name = 'Vanilla Unicorn',
        account = 'unicorn',
        job = 'unicorn',
        cashiers = {
            {
                coords = vector3(129.16, -1284.89, 29.27),
                radius = 0.25,
            },
        }
    },
    ['bahama'] = {
        name = 'Bahama Mamas',
        account = 'bahama',
        job = 'bahama',
        cashiers = {
            {
                coords = vector3(-1387.08, -588.64, 30.32),
                radius = 0.25,
            },
        }
    },
    ['beanmachine'] = {
        name = 'Bean Machine',
        account = 'beanmachine',
        job = 'beanmachine',
        cashiers = {
            {
                coords = vector3(120.27, -1037.31, 29.28),
                radius = 0.25,
            },
        }
    },
}

Config.Distance = {
    target = 2.0, 
    payment = 5.0 
}

Config.Timeout = {
    payment = 300000,
    notification = 5000
}

Config.Debug = false 