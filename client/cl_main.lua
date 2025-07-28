-- Aguardar ox_lib estar carregado
local function WaitForOxLib()
    while not exports.ox_lib do
        Wait(100)
    end
    return true
end

-- Aguardar todos os sistemas estarem prontos
local function WaitForSystems()
    local attempts = 0
    while attempts < 50 do -- 5 segundos máximo
        if exports.ox_lib and Framework and Config and Locales and _ then
            return true
        end
        attempts = attempts + 1
        Wait(100)
    end
    return false
end

-- Função para criar targets dos caixas
local function CreateCashierTargets()
    for companyId, company in pairs(Config.Companies) do
        -- Debug
        if Config.Debug then
            print(string.format('[CASHIER-DEBUG] Criando target para %s na posição %s', companyId,
                tostring(company.coords)))
        end

        -- Target único para todos (funcionários e clientes) usando addSphereZone
        local radius = (company.targetSize and company.targetSize.x) or 0.25
        exports.ox_target:addSphereZone({
            coords = company.coords,
            radius = radius,
            debug = Config.Debug,
            name = 'cashier_' .. companyId,
            options = {
                {
                    name = 'cashier_main_' .. companyId,
                    icon = 'fas fa-cash-register',
                    label = _('target_cashier'),
                    onSelect = function()
                        if Config.Debug then
                            print('[CASHIER-DEBUG] Target sistema de caixa clicado para: ' .. companyId)
                        end
                        OpenMainMenu(companyId)
                    end
                }
            }
        })
    end

    if Config.Debug then
        print('[CASHIER-DEBUG] Todos os targets criados com sucesso')
    end
end

-- Menu principal único
function OpenMainMenu(companyId)
    if not exports.ox_lib then
        print(_('[cashier_error_oxlib_unavailable]'))
        return
    end

    if Config.Debug then
        print(_('[cashier_debug_opening_menu]', companyId))
    end

    local playerData = Framework.GetPlayerData()
    local isEmployee = false

    -- Verificar se é funcionário
    if playerData and playerData.job and Config.Companies[companyId] then
        isEmployee = playerData.job.name == Config.Companies[companyId].job
    end

    local options = {}

    -- Opção 1: Fazer Cobrança
    table.insert(options, {
        title = _('register_charge'),
        icon = 'fas fa-plus',
        disabled = not isEmployee,
        onSelect = function()
            OpenChargeMenu(companyId)
        end
    })

    -- Opção 2: Efetuar Pagamento
    table.insert(options, {
        title = _('target_make_payment'),
        icon = 'fas fa-credit-card',
        onSelect = function()
            OpenPaymentMenu(companyId)
        end
    })

    -- Opção 3: Cancelar Cobrança
    if isEmployee then
        table.insert(options, {
            title = _('cancel'),
            icon = 'fas fa-times',
            onSelect = function()
                local success, alert = pcall(function()
                    return exports.ox_lib:alertDialog({
                        header = _('cancel'),
                        content = _('cancel_charge_confirm'),
                        centered = true,
                        cancel = true
                    })
                end)

                if success and alert == 'confirm' then
                    TriggerServerEvent('cashier:server:cancelCharge', companyId)
                end
            end
        })
    end

    local success, error = pcall(function()
        exports.ox_lib:registerContext({
            id = 'main_cashier_menu',
            title = _('cashier_menu'),
            options = options
        })

        exports.ox_lib:showContext('main_cashier_menu')
    end)

    if not success then
        print(_('[cashier_error_opening_menu]', tostring(error)))
        TriggerEvent('ox_lib:notify', {
            title = _('error'),
            description = _('error_opening_menu'),
            type = 'error',
            duration = 3000
        })
    end
end

-- Menu para fazer cobrança
function OpenChargeMenu(companyId)
    if Config.Debug then
        print(_('[cashier_debug_opening_charge_menu]', companyId))
    end

    local success, input = pcall(function()
        return exports.ox_lib:inputDialog(_('charge_menu'), {
            {
                type = 'number',
                label = _('charge_amount'),
                description = _('amount_description'),
                required = true,
                min = 1,
                max = 999999
            },
            {
                type = 'input',
                label = _('charge_description'),
                description = _('enter_description'),
                required = false,
                max = 50
            }
        })
    end)

    if not success then
        print(_('[cashier_error_opening_input]', tostring(input)))
        TriggerEvent('ox_lib:notify', {
            title = _('error'),
            description = _('error_opening_menu'),
            type = 'error',
            duration = 3000
        })
        return
    end

    if input then
        local amount = tonumber(input[1])
        local description = input[2] or 'Purchase'

        if amount and amount > 0 then
            if Config.Debug then
                print(string.format('[CASHIER-DEBUG] Registrando cobrança: Valor=%s, Descrição=%s', amount, description))
            end
            TriggerServerEvent('cashier:server:registerCharge', companyId, amount, description)
        else
            TriggerEvent('ox_lib:notify', {
                title = _('error'),
                description = _('invalid_amount'),
                type = 'error',
                duration = 3000
            })
        end
    end
end

-- Menu para efetuar pagamento
function OpenPaymentMenu(companyId)
    if Config.Debug then
        print(_('[cashier_debug_requesting_payment_info]', companyId))
    end

    -- Solicitar informações da cobrança do servidor
    TriggerServerEvent('cashier:server:requestPaymentInfo', companyId)
end

-- Event para receber informações de pagamento do servidor
RegisterNetEvent('cashier:client:showPaymentInfo', function(companyId, paymentData)
    if not paymentData then
        TriggerEvent('ox_lib:notify', {
            title = _('pending_charge'),
            description = _('no_charge_pending'),
            type = 'error',
            duration = 3000
        })
        return
    end

    local playerData = Framework.GetPlayerData()
    if not playerData or not playerData.money then
        print(_('[cashier_error_player_data_unavailable]'))
        return
    end

    local cashMoney = playerData.money.cash or 0
    local bankMoney = playerData.money.bank or 0

    local options = {}

    -- Informações da cobrança no topo
    table.insert(options, {
        title = string.format('$%s', paymentData.amount),
        description = paymentData.description,
        disabled = true
    })

    -- Opção de pagamento em dinheiro
    local cashDisabled = cashMoney < paymentData.amount
    table.insert(options, {
        title = _('pay_cash'),
        description = _('available_cash', cashMoney) .. (cashDisabled and ' (' .. _('insufficient_cash') .. ')' or ''),
        icon = 'fas fa-money-bill',
        disabled = cashDisabled,
        onSelect = function()
            ConfirmPayment(companyId, 'cash', paymentData.amount)
        end
    })

    -- Opção de pagamento no cartão/banco
    local bankDisabled = bankMoney < paymentData.amount
    table.insert(options, {
        title = _('pay_bank'),
        description = _('available_bank', bankMoney) .. (bankDisabled and ' (' .. _('insufficient_bank') .. ')' or ''),
        icon = 'fas fa-credit-card',
        disabled = bankDisabled,
        onSelect = function()
            ConfirmPayment(companyId, 'bank', paymentData.amount)
        end
    })

    -- Tentar registrar e mostrar o contexto
    local success, error = pcall(function()
        exports.ox_lib:registerContext({
            id = 'payment_menu',
            title = _('payment_menu'),
            options = options
        })

        exports.ox_lib:showContext('payment_menu')
    end)

    if not success then
        print(_('[cashier_error_showing_payment_menu]', tostring(error)))
        TriggerEvent('ox_lib:notify', {
            title = _('error'),
            description = _('error_opening_menu'),
            type = 'error',
            duration = 3000
        })
    end
end)

-- Função para confirmar pagamento
function ConfirmPayment(companyId, paymentMethod, amount)
    local methodText = paymentMethod == 'cash' and _('pay_cash'):lower() or _('pay_bank'):lower()

    local success, alert = pcall(function()
        return exports.ox_lib:alertDialog({
            header = _('confirm_payment', amount),
            content = _('confirm_payment_method', amount, methodText),
            centered = true,
            cancel = true,
            labels = {
                confirm = _('confirm_charge'),
                cancel = _('cancel')
            }
        })
    end)

    if not success then
        print(_('[cashier_error_showing_confirm_dialog]', tostring(alert)))
        return
    end

    if alert == 'confirm' then
        if Config.Debug then
            print(_('[cashier_debug_processing_payment]', amount, paymentMethod))
        end
        TriggerServerEvent('cashier:server:processPayment', companyId, paymentMethod)
    else
        if Config.Debug then
            print(_('[cashier_debug_payment_cancelled]'))
        end
    end
end

-- Event para quando o jogador spawna
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    CreateThread(function()
        Wait(3000)
        if WaitForSystems() then
        end
    end)
end)

RegisterNetEvent('qbx_core:playerLoaded', function()
    CreateThread(function()
        Wait(3000)
        if WaitForSystems() then
        end
    end)
end)

-- Inicialização principal do resource
CreateThread(function()
    Wait(2000)

    -- Aguardar todos os sistemas estarem prontos
    if not WaitForSystems() then
        print('[CASHIER-ERROR] Sistemas não puderam ser carregados!')
        return
    end

    -- Verificar se ox_target existe
    if GetResourceState('ox_target') ~= 'started' then
        print('[CASHIER-ERROR] ox_target não está iniciado!')
        return
    end

    -- Verificar se ox_lib existe
    if GetResourceState('ox_lib') ~= 'started' then
        print('[CASHIER-ERROR] ox_lib não está iniciado!')
        return
    end

    print('[CASHIER] Criando targets dos caixas...')
    CreateCashierTargets()
    print('[CASHIER] Sistema iniciado com sucesso!')

    -- Debug de locale após inicialização
    if Config.Debug then
        Wait(1000)
        Locale.Debug()
    end
end)
