Framework = {}

if Config.Framework == 'qb-core' then
    local QBCore = exports['qb-core']:GetCoreObject()
    
    Framework.GetPlayerData = function()
        return QBCore.Functions.GetPlayerData()
    end
    
    Framework.GetPlayer = function(source)
        return QBCore.Functions.GetPlayer(source)
    end
    
    Framework.GetPlayers = function()
        return QBCore.Functions.GetPlayers()
    end
    
    Framework.AddMoney = function(source, moneyType, amount)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            Player.Functions.AddMoney(moneyType, amount)
            return true
        end
        return false
    end
    
    Framework.RemoveMoney = function(source, moneyType, amount)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            return Player.Functions.RemoveMoney(moneyType, amount)
        end
        return false
    end
    
    Framework.GetMoney = function(source, moneyType)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            return Player.Functions.GetMoney(moneyType)
        end
        return 0
    end
    
    Framework.HasJob = function(source, job)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            return Player.PlayerData.job.name == job
        end
        return false
    end
    
    Framework.GetJob = function(source)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            return Player.PlayerData.job
        end
        return nil
    end
    
    Framework.AddMoneyToAccount = function(account, amount)
        if GetResourceState('qb-management') == 'started' then
            exports['qb-management']:AddMoney(account, amount)
            return true
        end
        return false
    end
    
    Framework.RemoveMoneyFromAccount = function(account, amount)
        if GetResourceState('qb-management') == 'started' then
            return exports['qb-management']:RemoveMoney(account, amount)
        end
        return false
    end
    
    Framework.GetAccountMoney = function(account)
        if GetResourceState('qb-management') == 'started' then
            return exports['qb-management']:GetAccount(account)
        end
        return 0
    end
    
    Framework.Notify = function(source, message, type, duration)
        TriggerClientEvent('ox_lib:notify', source, {
            title = _('cashier_notify_title'),
            description = message,
            type = type,
            duration = duration or 5000
        })
    end

elseif Config.Framework == 'qbx_core' then
    
    Framework.GetPlayerData = function()
        return exports.qbx_core:GetPlayerData()
    end
    
    Framework.GetPlayer = function(source)
        return exports.qbx_core:GetPlayer(source)
    end
    
    Framework.GetPlayers = function()
        return exports.qbx_core:GetPlayersData()
    end
    
    Framework.AddMoney = function(source, moneyType, amount)
        return exports.qbx_core:AddMoney(source, moneyType, amount)
    end
    
    Framework.RemoveMoney = function(source, moneyType, amount)
        return exports.qbx_core:RemoveMoney(source, moneyType, amount)
    end
    
    Framework.GetMoney = function(source, moneyType)
        return exports.qbx_core:GetMoney(source, moneyType)
    end
    
    Framework.HasJob = function(source, job)
        local Player = exports.qbx_core:GetPlayer(source)
        if Player then
            return Player.PlayerData.job.name == job
        end
        return false
    end
    
    Framework.GetJob = function(source)
        local Player = exports.qbx_core:GetPlayer(source)
        if Player then
            return Player.PlayerData.job
        end
        return nil
    end
    
    Framework.AddMoneyToAccount = function(account, amount)
        -- QBX Management 
        if GetResourceState('qbx_management') == 'started' then
            -- Método 1: Tentar AddJobMoney
            local success1, result1 = pcall(function()
                return exports['qbx_management']:AddJobMoney(account, amount)
            end)
            if success1 then
                Framework.Debug('AddJobMoney usado com sucesso para: ' .. account)
                return true
            end
            
            -- Método 2: Tentar AddMoney diretamente
            local success2, result2 = pcall(function()
                return exports['qbx_management']:AddMoney(account, amount)
            end)
            if success2 then
                Framework.Debug('AddMoney usado com sucesso para: ' .. account)
                return true
            end
            
            -- Método 3: Tentar AddGangMoney (se for gang)
            local success3, result3 = pcall(function()
                return exports['qbx_management']:AddGangMoney(account, amount)
            end)
            if success3 then
                Framework.Debug('AddGangMoney usado com sucesso para: ' .. account)
                return true
            end
            
            Framework.Debug('Nenhum método de AddMoney funcionou para qbx_management')
        end
        
        -- Fallback para qb-management
        if GetResourceState('qb-management') == 'started' then
            local success, result = pcall(function()
                return exports['qb-management']:AddMoney(account, amount)
            end)
            if success then
                Framework.Debug('qb-management AddMoney usado como fallback')
                return true
            end
        end
        
        Framework.Debug('Nenhum sistema de management disponível para AddMoney')
        return false
    end
    
    Framework.RemoveMoneyFromAccount = function(account, amount)
        -- QBX Management
        if GetResourceState('qbx_management') == 'started' then
            -- Método 1:  RemoveJobMoney
            local success1, result1 = pcall(function()
                return exports['qbx_management']:RemoveJobMoney(account, amount)
            end)
            if success1 and result1 then
                Framework.Debug('RemoveJobMoney usado com sucesso para: ' .. account)
                return true
            end
            
            -- Método 2:  RemoveMoney diretamente
            local success2, result2 = pcall(function()
                return exports['qbx_management']:RemoveMoney(account, amount)
            end)
            if success2 and result2 then
                Framework.Debug('RemoveMoney usado com sucesso para: ' .. account)
                return true
            end
            
            -- Método 3: RemoveGangMoney (se for gang)
            local success3, result3 = pcall(function()
                return exports['qbx_management']:RemoveGangMoney(account, amount)
            end)
            if success3 and result3 then
                Framework.Debug('RemoveGangMoney usado com sucesso para: ' .. account)
                return true
            end
            
            Framework.Debug('Nenhum método de RemoveMoney funcionou para qbx_management')
        end
        
        -- Fallback para qb-management
        if GetResourceState('qb-management') == 'started' then
            local success, result = pcall(function()
                return exports['qb-management']:RemoveMoney(account, amount)
            end)
            if success then
                Framework.Debug('qb-management RemoveMoney usado como fallback')
                return result
            end
        end
        
        Framework.Debug('Nenhum sistema de management disponível para RemoveMoney')
        return false
    end
    
    Framework.GetAccountMoney = function(account)
        if GetResourceState('qbx_management') == 'started' then
            local success1, result1 = pcall(function()
                return exports['qbx_management']:GetJobMoney(account)
            end)
            if success1 and result1 then
                Framework.Debug('GetJobMoney usado com sucesso para: ' .. account)
                return result1
            end
            
            local success2, result2 = pcall(function()
                return exports['qbx_management']:GetAccount(account)
            end)
            if success2 and result2 then
                Framework.Debug('GetAccount usado com sucesso para: ' .. account)
                return result2
            end
            
            local success3, result3 = pcall(function()
                return exports['qbx_management']:GetGangMoney(account)
            end)
            if success3 and result3 then
                Framework.Debug('GetGangMoney usado com sucesso para: ' .. account)
                return result3
            end
            
            Framework.Debug('Nenhum método de GetAccount funcionou para qbx_management')
        end
        
        -- Fallback para qb-management
        if GetResourceState('qb-management') == 'started' then
            local success, result = pcall(function()
                return exports['qb-management']:GetAccount(account)
            end)
            if success and result then
                Framework.Debug('qb-management GetAccount usado como fallback')
                return result
            end
        end
        
        Framework.Debug('Nenhum sistema de management disponível para GetAccount')
        return 0
    end
    
    Framework.Notify = function(source, message, type, duration)
        TriggerClientEvent('ox_lib:notify', source, {
            title = _('cashier_notify_title'),
            description = message,
            type = type,
            duration = duration or 5000
        })
    end
end

-- Função universal para verificar se resource existe
Framework.IsResourceStarted = function(resourceName)
    return GetResourceState(resourceName) == 'started'
end

-- Função para debug
Framework.Debug = function(message)
    if Config.Debug then
        print(string.format('[CASHIER-DEBUG] %s', message))
    end
end

-- Função para log de transações
Framework.LogTransaction = function(type, data)
    if Config.Debug then
        local logMessage = string.format('[CASHIER-LOG] %s: %s', type, json.encode(data))
        print(logMessage)
    end
end

-- Validações de segurança
Framework.ValidateAmount = function(amount)
    return type(amount) == 'number' and amount > 0 and amount <= 999999
end

Framework.ValidatePlayer = function(source)
    return source and GetPlayerName(source) ~= nil
end

Framework.ValidateJob = function(source, jobName)
    if not Framework.ValidatePlayer(source) or not jobName then
        return false
    end
    return Framework.HasJob(source, jobName)
end

-- Função para calcular distância
Framework.GetDistance = function(pos1, pos2)
    return #(pos1 - pos2)
end

-- Função para verificar se jogador está próximo
Framework.IsPlayerNearby = function(source, coords, maxDistance)
    if not Framework.ValidatePlayer(source) then
        return false
    end
    
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local distance = Framework.GetDistance(playerCoords, coords)
    
    return distance <= maxDistance
end

-- Função para obter todos os jogadores próximos
Framework.GetNearbyPlayers = function(source, maxDistance)
    local players = {}
    local sourceCoords = GetEntityCoords(GetPlayerPed(source))
    
    for _, playerId in pairs(GetPlayers()) do
        local targetId = tonumber(playerId)
        if targetId ~= source then
            local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
            local dist = Framework.GetDistance(sourceCoords, targetCoords)
            
            if dist <= maxDistance then
                table.insert(players, {
                    id = targetId,
                    distance = dist,
                    name = GetPlayerName(targetId)
                })
            end
        end
    end
    
    -- Ordenar por distância
    table.sort(players, function(a, b) return a.distance < b.distance end)
    return players
end

-- Função para formatar dinheiro
Framework.FormatMoney = function(amount)
    return string.format('$%s', tostring(amount):reverse():gsub('(%d%d%d)', '%1,'):reverse():gsub('^,', ''))
end

-- Função para converter tipo de dinheiro
Framework.GetMoneyLabel = function(moneyType)
    local labels = {
        cash = 'Dinheiro',
        bank = 'Banco/Cartão'
    }
    return labels[moneyType] or 'Desconhecido'
end

-- Função para obter nome do personagem
Framework.GetPlayerName = function(source)
    if Config.Framework == 'qb-core' then
        local Player = exports['qb-core']:GetCoreObject().Functions.GetPlayer(source)
        if Player and Player.PlayerData and Player.PlayerData.charinfo then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        end
    elseif Config.Framework == 'qbx_core' then
        local Player = exports.qbx_core:GetPlayer(source)
        if Player and Player.PlayerData and Player.PlayerData.charinfo then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        end
    end
    
    -- Fallback para GetPlayerName nativo (Steam)
    return GetPlayerName(source) or 'Desconhecido'
end

-- Função para verificar se empresa tem múltiplos caixas
Framework.HasMultipleCashiers = function(companyId)
    local company = Config.Companies[companyId]
    if not company then return false end
    
    return company.cashiers and #company.cashiers > 1
end

-- Função para obter total de caixas de uma empresa
Framework.GetCashierCount = function(companyId)
    local company = Config.Companies[companyId]
    if not company then return 0 end
    
    if company.cashiers then
        return #company.cashiers
    elseif company.coords then
        return 1
    end
    
    return 0
end

-- Função para validar se o ID do caixa é válido
Framework.ValidateCashierId = function(companyId, cashierId)
    local company = Config.Companies[companyId]
    if not company then return false end
    
    if company.cashiers then
        return cashierId >= 1 and cashierId <= #company.cashiers
    elseif company.coords then
        return cashierId == 1
    end
    
    return false
end