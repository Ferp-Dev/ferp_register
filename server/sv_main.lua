local activeCharges = {}

-- Função para calcular comissão
local function CalculateCommission(amount)
    if Config.Commission.enabled then
        return math.floor(amount * (Config.Commission.percentage / 100))
    end
    return 0
end

-- Função para obter coordenadas do caixa
local function GetCashierCoords(companyId, cashierId)
    local company = Config.Companies[companyId]
    if not company then return nil end
    
    -- Novo formato com múltiplos caixas
    if company.cashiers then
        return company.cashiers[cashierId] and company.cashiers[cashierId].coords or nil
    end
    
    -- Formato antigo para compatibilidade
    if company.coords and cashierId == 1 then
        return company.coords
    end
    
    return nil
end

-- Event para registrar cobrança
RegisterNetEvent('cashier:server:registerCharge', function(companyId, cashierId, amount, description)
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
    
    -- Verificar se o caixa existe
    local cashierCoords = GetCashierCoords(companyId, cashierId)
    if not cashierCoords then
        Framework.Notify(source, _('invalid_cashier'), 'error')
        return
    end
    
    -- Verificar distância
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local distance = #(playerCoords - cashierCoords)
    
    if distance > Config.Distance.target then
        Framework.Notify(source, _('too_far_from_cashier'), 'error')
        return
    end
    
    -- Criar chave única para empresa + caixa
    local chargeKey = companyId .. '_' .. cashierId
    
    -- Registrar cobrança para a empresa/caixa específico
    activeCharges[chargeKey] = {
        companyId = companyId,
        cashierId = cashierId,
        amount = amount,
        description = description,
        cashierEmployeeId = source,
        cashierName = Framework.GetPlayerName(source),
        timestamp = os.time(),
        coords = cashierCoords
    }
    
    -- Notificar funcionário
    Framework.Notify(source, _('charge_registered', amount), 'success')
    
        -- Timeout para expirar a cobrança
        SetTimeout(Config.Timeout.payment, function()
            if activeCharges[chargeKey] and activeCharges[chargeKey].timestamp == activeCharges[chargeKey].timestamp then
                activeCharges[chargeKey] = nil
                if Framework.GetPlayerName(source) then -- Verificar se o jogador ainda está online
                    Framework.Notify(source, _('charge_expired'), 'error')
                end
            end
        end)
end)

-- Event para cancelar cobrança
RegisterNetEvent('cashier:server:cancelCharge', function(companyId, cashierId)
    local source = source
    local company = Config.Companies[companyId]
    
    if not company then return end
    
    -- Verificar se o jogador tem o job correto
    if not Framework.HasJob(source, company.job) then
        Framework.Notify(source, _('not_authorized'), 'error')
        return
    end
    
    local chargeKey = companyId .. '_' .. cashierId
    
    -- Verificar se há cobrança ativa
    if not activeCharges[chargeKey] then
        Framework.Notify(source, _('no_active_charge'), 'error')
        return
    end
    
    -- Cancelar cobrança
    activeCharges[chargeKey] = nil
    Framework.Notify(source, _('charge_cleared_success'), 'success')
end)

RegisterNetEvent('cashier:server:requestPaymentInfo', function(companyId, cashierId)
    local source = source
    local company = Config.Companies[companyId]
    
    if not company then return end
    
    local chargeKey = companyId .. '_' .. cashierId
    
    -- Verificar se há cobrança ativa para esta empresa/caixa
    local chargeData = activeCharges[chargeKey]
    
    if not chargeData then
        TriggerClientEvent('cashier:client:showPaymentInfo', source, companyId, cashierId, nil)
        return
    end
    
    -- Verificar distância do caixa específico
    local cashierCoords = GetCashierCoords(companyId, cashierId)
    if not cashierCoords then
        Framework.Notify(source, _('invalid_cashier'), 'error')
        return
    end
    
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local distance = #(playerCoords - cashierCoords)
    
    if distance > Config.Distance.target then
        Framework.Notify(source, _('too_far_from_cashier'), 'error')
        return
    end
    
    -- Enviar informações da cobrança para o cliente
    TriggerClientEvent('cashier:client:showPaymentInfo', source, companyId, cashierId, chargeData)
end)

-- Event para processar pagamento
RegisterNetEvent('cashier:server:processPayment', function(companyId, cashierId, paymentMethod)
    local source = source
    local company = Config.Companies[companyId]
    local chargeKey = companyId .. '_' .. cashierId
    local chargeData = activeCharges[chargeKey]
    
    if not company or not chargeData then
        Framework.Notify(source, _('charge_not_found'), 'error')
        return
    end
    
    local amount = chargeData.amount
    local cashierEmployeeId = chargeData.cashierEmployeeId
    
    -- Verificar distância do caixa específico
    local cashierCoords = GetCashierCoords(companyId, cashierId)
    if not cashierCoords then
        Framework.Notify(source, _('invalid_cashier'), 'error')
        return
    end
    
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local distance = #(playerCoords - cashierCoords)
    
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
                        Framework.GetPlayerName(source),
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
                        Framework.GetPlayerName(source),
                        company.name,
                        'deposit'
                    )
                end

        -- Calcular e dar comissão ao funcionário
        local commission = CalculateCommission(amount)
        if commission > 0 and Framework.GetPlayerName(cashierEmployeeId) then
            Framework.AddMoney(cashierEmployeeId, 'cash', commission)
            Framework.Notify(cashierEmployeeId, _('commission_received', commission), 'success')
        end

        -- Notificar cliente
        Framework.Notify(source, _('payment_successful'), 'success')

        -- Notificar funcionário sobre o pagamento
        if Framework.GetPlayerName(cashierEmployeeId) then
            Framework.Notify(cashierEmployeeId, _('payment_received', amount, Framework.GetPlayerName(source)), 'success')
        end

        -- Limpar cobrança ativa
        activeCharges[chargeKey] = nil

        -- Log da transação
        if Config.Debug then
            print(_('[cashier_debug_payment_processed]', Framework.GetPlayerName(source), amount, chargeData.cashierName, company.name, 'Caixa #' .. cashierId))
        end
    else
        local errorMsg = paymentMethod == 'cash' and 'insufficient_cash' or 'insufficient_bank'
        Framework.Notify(source, _(errorMsg), 'error')
    end
end)

-- Exports para outros recursos (atualizados para múltiplos caixas)
exports('registerCharge', function(companyId, cashierId, amount, description)
    local company = Config.Companies[companyId]
    if not company then return false end
    
    cashierId = cashierId or 1 -- Default para primeiro caixa se não especificado
    local chargeKey = companyId .. '_' .. cashierId
    
    activeCharges[chargeKey] = {
        companyId = companyId,
        cashierId = cashierId,
        amount = amount,
        description = description or _('pending_charge'),
        cashierEmployeeId = 'system',
        cashierName = 'System',
        timestamp = os.time(),
        coords = GetCashierCoords(companyId, cashierId)
    }
    
    return true
end)

exports('getActiveCharges', function()
    return activeCharges
end)

exports('clearCharge', function(companyId, cashierId)
    cashierId = cashierId or 1 -- Default para primeiro caixa se não especificado
    local chargeKey = companyId .. '_' .. cashierId
    
    if activeCharges[chargeKey] then
        activeCharges[chargeKey] = nil
        return true
    end
    return false
end)

-- Export para obter cobranças de uma empresa específica
exports('getCompanyCharges', function(companyId)
    local companyCharges = {}
    for chargeKey, chargeData in pairs(activeCharges) do
        if chargeData.companyId == companyId then
            companyCharges[chargeKey] = chargeData
        end
    end
    return companyCharges
end)

-- Export para limpar todas as cobranças de uma empresa
exports('clearCompanyCharges', function(companyId)
    local cleared = 0
    for chargeKey, chargeData in pairs(activeCharges) do
        if chargeData.companyId == companyId then
            activeCharges[chargeKey] = nil
            cleared = cleared + 1
        end
    end
    return cleared
end)

-- Função para limpar cobranças expiradas
CreateThread(function()
    while true do
        Wait(60000)
        
        local currentTime = os.time()
        for chargeKey, charge in pairs(activeCharges) do
            if currentTime - charge.timestamp > (Config.Timeout.payment / 1000) then
                activeCharges[chargeKey] = nil
                if Config.Debug then
                    print(_('[cashier_debug_charge_expired]', charge.companyId, 'Caixa #' .. charge.cashierId))
                end
            end
        end
    end
end)