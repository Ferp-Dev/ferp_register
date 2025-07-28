-- Inicialização do sistema de Locales
Locales = {}

-- Sistema de Localização
Locale = {}

-- Função para obter texto localizado
function Locale.Get(key, ...)
    local currentLocale = Config and Config.Locale or 'en'
    
    if not Locales[currentLocale] then
        print('^1[CASHIER-ERROR] Locale ' .. currentLocale .. ' not found! Using fallback: en^0')
        currentLocale = 'en'
    end
    
    if not Locales[currentLocale] then
        print('^1[CASHIER-ERROR] Fallback locale en not found!^0')
        return key
    end
    
    local text = Locales[currentLocale][key]
    
    if not text then
        print('^3[CASHIER-WARNING] Locale key "' .. key .. '" not found in ' .. currentLocale .. '^0')
        -- Tentar usar inglês como fallback
        if currentLocale ~= 'en' and Locales['en'] and Locales['en'][key] then
            text = Locales['en'][key]
        else
            return key
        end
    end
    
    -- Se há argumentos, formatar o texto
    if ... then
        return string.format(text, ...)
    end
    
    return text
end

-- Função de conveniência para usar no código
function _(key, ...)
    return Locale.Get(key, ...)
end

-- Função para validar se todas as chaves existem
function Locale.ValidateKeys(localeCode)
    if not Locales[localeCode] then
        return false, "Locale not found"
    end
    
    local englishKeys = {}
    local currentKeys = {}
    
    -- Pegar todas as chaves do inglês (base)
    if Locales['en'] then
        for key, _ in pairs(Locales['en']) do
            englishKeys[key] = true
        end
    end
    
    -- Pegar todas as chaves do idioma atual
    for key, _ in pairs(Locales[localeCode]) do
        currentKeys[key] = true
    end
    
    local missingKeys = {}
    local extraKeys = {}
    
    -- Verificar chaves faltando
    for key, _ in pairs(englishKeys) do
        if not currentKeys[key] then
            table.insert(missingKeys, key)
        end
    end
    
    -- Verificar chaves extras
    for key, _ in pairs(currentKeys) do
        if not englishKeys[key] then
            table.insert(extraKeys, key)
        end
    end
    
    return true, {
        missing = missingKeys,
        extra = extraKeys,
        total_base = #englishKeys,
        total_current = #currentKeys
    }
end

-- Função para debug de locales
function Locale.Debug()
    if not Config or not Config.Debug then return end
    
    print('^2[CASHIER-LOCALE] === LOCALE DEBUG ===^0')
    print('^2[CASHIER-LOCALE] Current locale: ' .. (Config.Locale or 'en') .. '^0')
    
    for localeCode, _ in pairs(Locales) do
        local isValid, result = Locale.ValidateKeys(localeCode)
        if isValid then
            print(string.format('^2[CASHIER-LOCALE] %s: %d keys (Missing: %d, Extra: %d)^0', 
                localeCode, 
                result.total_current, 
                #result.missing, 
                #result.extra
            ))
            
            if #result.missing > 0 then
                print('^3[CASHIER-LOCALE] Missing keys in ' .. localeCode .. ': ' .. table.concat(result.missing, ', ') .. '^0')
            end
            
            if #result.extra > 0 then
                print('^3[CASHIER-LOCALE] Extra keys in ' .. localeCode .. ': ' .. table.concat(result.extra, ', ') .. '^0')
            end
        else
            print('^1[CASHIER-LOCALE] Invalid locale: ' .. localeCode .. ' - ' .. result .. '^0')
        end
    end
    
    print('^2[CASHIER-LOCALE] === END LOCALE DEBUG ===^0')
end