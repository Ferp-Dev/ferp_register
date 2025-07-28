local activeCharges = {}

-- Função para calcular comissão
local function CalculateCommission(amount)
    if Config.Commission.enabled then
        return math.floor(amount * (Config.Commission.percentage / 100))
    end
    return 0
end

-- Event para registrar cobrança (funcionário)
RegisterNetEvent('cashier:server:registerCharge', function(companyId, amount, description)
    local source = source
    local company = Config.Companies[companyId]
    
    if not company then return end
    
    -- Verificar se o jogador tem o job correto
    if not Framework.HasJob(source, company.job) then
        Framework.Notify(source, _('not_authorized'), 'error')
        return
    end
    
    if amount <= 0 then
        Framework.Notify(source, _('invalid_amount'), 'error')
        return
    end
    
    -- Registrar cobrança para a empresa
    activeCharges[companyId] = {
        amount = amount,
        description = description,
        cashierId = source,
        cashierName = GetPlayerName(source),
        timestamp = os.time()
    }
    
    -- Notificar funcionário
    Framework.Notify(source, _('charge_registered', amount), 'success')
    
    SetTimeout(Config.Timeout.payment, function()
        if activeCharges[companyId] and activeCharges[companyId].timestamp == activeCharges[companyId].timestamp then
            activeCharges[companyId] = nil
            Framework.Notify(source, _('charge_expired'), 'error')
        end
    end)
end)

-- Event para cancelar cobrança
RegisterNetEvent('cashier:server:cancelCharge', function(companyId)
    local source = source
    local company = Config.Companies[companyId]
    
    if not company then return end
    
    -- Verificar se o jogador tem o job correto
    if not Framework.HasJob(source, company.job) then
        Framework.Notify(source, _('not_authorized'), 'error')
        return
    end
    
    -- Verificar se há cobrança ativa
    if not activeCharges[companyId] then
        Framework.Notify(source, _('no_active_charge'), 'error')
        return
    end
    
    -- Cancelar cobrança
    activeCharges[companyId] = nil
    Framework.Notify(source, _('charge_cleared_success'), 'success')
end)

RegisterNetEvent('cashier:server:requestPaymentInfo', function(companyId)
    local source = source
    local company = Config.Companies[companyId]
    
    if not company then return end
    
    -- Verificar se há cobrança ativa para esta empresa
    local chargeData = activeCharges[companyId]
    
    if not chargeData then
        TriggerClientEvent('cashier:client:showPaymentInfo', source, companyId, nil)
        return
    end
    
    -- Verificar distância do caixa
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local distance = #(playerCoords - company.coords)
    
    if distance > Config.Distance.target then
        Framework.Notify(source, _('too_far_from_cashier'), 'error')
        return
    end
    
    -- Enviar informações da cobrança para o cliente
    TriggerClientEvent('cashier:client:showPaymentInfo', source, companyId, chargeData)
end)

-- Event para processar pagamento
RegisterNetEvent('cashier:server:processPayment', function(companyId, paymentMethod)
    local source = source
    local company = Config.Companies[companyId]
    local chargeData = activeCharges[companyId]
    
    if not company or not chargeData then
        Framework.Notify(source, _('charge_not_found'), 'error')
        return
    end
    
    local amount = chargeData.amount
    local cashierId = chargeData.cashierId
    
    -- Verificar distância do caixa
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local distance = #(playerCoords - company.coords)
    
    if distance > Config.Distance.target then
        Framework.Notify(source, _('too_far_from_cashier'), 'error')
        return
    end
    
    -- Verificar se o cliente tem dinheiro suficiente
    local playerMoney = Framework.GetMoney(source, paymentMethod)
    
    if playerMoney < amount then
        local errorMsg = paymentMethod == 'cash' and 'insufficient_cash' or 'insufficient_bank'
        Framework.Notify(source, _(errorMsg), 'error')
        return
    end
    
    -- Processar pagamento
    if Framework.RemoveMoney(source, paymentMethod, amount) then
        local player = Framework.GetPlayer and Framework.GetPlayer(source)
        local citizenid = player and player.PlayerData and player.PlayerData.citizenid or tostring(source)
        -- Registrar saída do player no Renewed-Banking apenas se for pagamento no banco/cartão
        if (paymentMethod == 'bank' or paymentMethod == 'card') and GetResourceState('Renewed-Banking') == 'started' then
            exports['Renewed-Banking']:handleTransaction(
                citizenid,
                'Cashier Payment',
                amount,
                chargeData.description or 'Payment at cashier',
                GetPlayerName(source),
                company.name,
                'withdraw'
            )
        end

        -- Adicionar dinheiro à conta da empresa
        Framework.AddMoneyToAccount(company.account, amount)
        -- Registrar transação simples no Renewed-Banking
        if GetResourceState('Renewed-Banking') == 'started' then
            exports['Renewed-Banking']:handleTransaction(
                company.account,
                'Cashier Payment',
                amount,
                chargeData.description or 'Payment at cashier',
                GetPlayerName(source),
                company.name,
                'deposit'
            )
        end

        -- Calcular e dar comissão ao funcionário
        local commission = CalculateCommission(amount)
        if commission > 0 and GetPlayerName(cashierId) then
            Framework.AddMoney(cashierId, 'cash', commission)
            Framework.Notify(cashierId, _('commission_received', commission), 'success')
        end

        -- Notificar cliente
        Framework.Notify(source, _('payment_successful'), 'success')

        -- Notificar funcionário sobre o pagamento
        if GetPlayerName(cashierId) then
            Framework.Notify(cashierId, _('payment_received', amount, GetPlayerName(source)), 'success')
        end

        -- Limpar cobrança ativa
        activeCharges[companyId] = nil

        -- Log da transação
        if Config.Debug then
            print(_('[cashier_debug_payment_processed]', GetPlayerName(source), amount, chargeData.cashierName, company.name))
        end
    else
        local errorMsg = paymentMethod == 'cash' and 'insufficient_cash' or 'insufficient_bank'
        Framework.Notify(source, _(errorMsg), 'error')
    end
end)

-- Exports para outros recursos
exports('registerCharge', function(companyId, amount, description)
    local company = Config.Companies[companyId]
    if not company then return false end
    
    activeCharges[companyId] = {
        amount = amount,
        description = description or _('pending_charge'),
        cashierId = 'system',
        cashierName = 'System',
        timestamp = os.time()
    }
    
    return true
end)

exports('getActiveCharges', function()
    return activeCharges
end)

exports('clearCharge', function(companyId)
    if activeCharges[companyId] then
        activeCharges[companyId] = nil
        return true
    end
    return false
end)

-- Função para limpar cobranças expiradas
CreateThread(function()
    while true do
        Wait(60000) -- Verificar a cada minuto
        
        local currentTime = os.time()
        for companyId, charge in pairs(activeCharges) do
            if currentTime - charge.timestamp > (Config.Timeout.payment / 1000) then
                activeCharges[companyId] = nil
                if Config.Debug then
                    print(_('[cashier_debug_charge_expired]', companyId))
                end
            end
        end
    end
end)