Config = {}

-- Sistema Framework
Config.Framework = 'qbx_core' -- 'qb-core' ou 'qbx_core'

-- Sistema de Comissão
Config.Commission = {
    enabled = true, -- Habilitar sistema de comissão
    percentage = 5.0 -- Porcentagem da comissão (5%)
}

-- Sistema de Idioma
Config.Locale = 'en' -- 'en', 'pt-br'

-- Configurações das Empresas
Config.Companies = {
    ['burgershot'] = {
        name = 'Burger Shot',
        account = 'burgershot',
        job = 'burgershot',
        coords = vector3(-584.17, -1058.79, 22.45),
        targetSize = vector3(0.25, 0.25, 0.4)
    },
    ['pizzathis'] = {
        name = 'Pizza This',
        account = 'pizzathis', 
        job = 'pizzathis',
        coords = vector3(809.23, -750.32, 26.78),
        targetSize = vector3(0.25, 0.25, 0.4)
    },
    ['unicorn'] = {
        name = 'Vanilla Unicorn',
        account = 'unicorn',
        job = 'unicorn',
        coords = vector3(129.16, -1284.89, 29.27),
        targetSize = vector3(0.25, 0.25, 0.4)
    },
    ['bahama'] = {
        name = 'Bahama Mamas',
        account = 'bahama',
        job = 'bahama',
        coords = vector3(-1387.08, -588.64, 30.32),
        targetSize = vector3(0.25, 0.25, 0.4)
    },
    ['beanmachine'] = {
        name = 'Bean Machine',
        account = 'beanmachine',
        job = 'beanmachine',
        coords = vector3(120.27, -1037.31, 29.28),
        targetSize = vector3(0.25, 0.25, 0.4)
    },
    -- Adicione mais empresas conforme necessário
}

-- Configurações de Distância
Config.Distance = {
    target = 2.0, -- Distância para interagir com o caixa
    payment = 5.0 -- Distância máxima para processar pagamento
}

-- Configurações de Tempo
Config.Timeout = {
    payment = 300000, -- Tempo limite para cobrança ficar ativa (5 minutos)
    notification = 5000 -- Tempo das notificações
}

-- Configurações de Debug
Config.Debug = false -- Ativar  para debug