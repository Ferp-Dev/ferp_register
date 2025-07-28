# Cashier Register System

A complete and highly customizable cashier system for QBCore/QBX servers using ox_lib and ox_target.

## 🚀 Features

- Compatible with QBCore and QBX frameworks
- Modern NUI interface with ox_lib
- ox_target for interactive zones (sphere/box)
- Cash and card/bank payments
- Configurable commission system per company
- Multi-language support (locales)
- Full integration via exports and events
- Timeout system for charges and payments
- Debug mode for troubleshooting
- Flexible company setup (multiple locations/jobs)

## 📋 Dependencies

- ox_lib (menus, notifications, dialogs)
- ox_target (interaction zones)
- qb-core or qbx_core (framework)
- qb-management or qbx_management (company accounts)

## 🛠️ Installation

1. Extract the resource to your `resources` folder
2. Configure your companies in `config.lua`
3. Set your preferred language in `locales/en.lua` or `locales/pt-br.lua`
4. Add the resource to your `server.cfg`:
   ```
   ensure ferp_register
   ```

## ⚙️ Configuration

### config.lua

```lua
Config.Framework = 'qb-core' -- or 'qbx_core'
Config.Commission = {
    enabled = true,
    percentage = 5.0
}
Config.Locale = 'en' -- or 'pt-br'
Config.Companies = {
    ['burgershot'] = {
        name = 'Burger Shot',
        account = 'burgershot',
        job = 'burgershot',
        coords = vector3(-1193.91, -906.24, 13.98),
        targetSize = vector3(2.0, 2.0, 2.0)
    },
    -- Add more companies as needed
}
Config.Distance = {
    target = 3.0,
    payment = 5.0
}
Config.Timeout = {
    payment = 300000,
    notification = 5000
}
Config.Debug = false
```

## 🎮 Usage

### Employee Flow
1. Go to your company's cash register zone
2. Press the interaction key (ox_target)
3. Select the customer
4. Enter the sale amount and description
5. Wait for the customer to pay

## 📤 Exports & API

All exports are available for integration with other scripts:

#### processCashierPayment
```lua
local paymentId = exports['cashier-system']:processCashierPayment(companyId, playerId, amount)
```

#### cancelPayment
```lua
local success = exports['cashier-system']:cancelPayment(paymentId)
```

#### getActivePayments
```lua
local payments = exports['cashier-system']:getActivePayments()
```

#### registerCharge
```lua
local success = exports['cashier-system']:registerCharge(companyId, amount, description)
```

#### getActiveCharges
```lua
local charges = exports['cashier-system']:getActiveCharges()
```

#### clearCharge
```lua
local success = exports['cashier-system']:clearCharge(companyId)
```

## � Events

You can listen to these events for custom logic:

- `cashier:client:showPaymentInfo` (client): Triggered when payment info is received
- `cashier:server:registerCharge` (server): Triggered when a charge is registered
- `cashier:server:processPayment` (server): Triggered when a payment is processed
- `cashier:server:cancelCharge` (server): Triggered when a charge is cancelled

## 🧩 Integration Examples

### Shop System Example
```lua
RegisterNetEvent('shop:buyItem', function(itemData)
    local source = source
    local amount = itemData.price
    local paymentId = exports['cashier-system']:processCashierPayment(
        'burgershot',
        source,
        amount
    )
    if paymentId then
        print('Payment created:', paymentId)
    end
end)
```

### Check Payment Example
```lua
CreateThread(function()
    while true do
        Wait(5000)
        local activePayments = exports['cashier-system']:getActivePayments()
        for paymentId, data in pairs(activePayments) do
            if data.timestamp + 60 < os.time() then
                exports['cashier-system']:cancelPayment(paymentId)
            end
        end
    end
end)
```

## 📝 Technical Notes

- All notifications and menu texts are localized (see `locales/en.lua` and `locales/pt-br.lua`).
- Company zones use ox_target's sphere or box zones (configurable).
- Commission is paid automatically to the employee who registered the charge.
- Payments expire after the configured timeout.
- Debug mode prints extra info to server/client console.
- All server-side logic is framework-agnostic (QBCore or QBX).
- You can add/remove companies, jobs, and zones freely in `config.lua`.

## 💡 Tips

- For custom integration, use the exports and events to trigger charges/payments from any script.
- You can translate all texts by editing the locale files.
- For advanced setups, use multiple zones, jobs, or custom logic in your own scripts.

## 📚 Credits

- Developed by Ferp.Dev
- Uses ox_lib and ox_target by overextended.dev