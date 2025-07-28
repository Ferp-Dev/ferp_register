-- Verificar se Locales existe, se não criar
if not Locales then
    Locales = {}
end

Locales['en'] = {
    ['cashier_notify_title'] = 'Cashier',
    ['cashier_debug_payment_processed'] = 'Payment processed: %s paid $%s to %s (Company: %s)',
    ['cashier_debug_charge_expired'] = 'Charge expired - %s',
    ['cashier_error_oxlib_unavailable'] = 'ox_lib is not available!',
    ['cashier_debug_opening_menu'] = 'Opening main menu for: %s',
    ['cashier_error_opening_menu'] = 'Error opening main menu: %s',
    ['error_opening_menu'] = 'Error opening menu',
    ['error'] = 'Error',
    ['cashier_debug_opening_charge_menu'] = 'Opening charge menu for: %s',
    ['cashier_error_opening_input'] = 'Error opening inputDialog: %s',
    ['cashier_debug_requesting_payment_info'] = 'Requesting payment info for: %s',
    ['cashier_error_player_data_unavailable'] = 'Player data not available',
    ['cashier_error_showing_payment_menu'] = 'Error showing payment menu: %s',
    ['cashier_error_showing_confirm_dialog'] = 'Error showing confirm dialog: %s',
    ['cashier_debug_processing_payment'] = 'Processing payment: %s via %s',
    ['cashier_debug_payment_cancelled'] = 'Payment cancelled',
    ['cancel_charge_confirm'] = 'Cancel pending charge?',
    -- Menu Titles
    ['cashier_menu'] = 'Cash Register',
    ['payment_menu'] = 'Make Payment',
    ['charge_menu'] = 'Register Charge',
    
    -- Employee Menu Options
    ['register_charge'] = 'Register Charge',
    ['charge_amount'] = 'Charge Amount',
    ['charge_description'] = 'Description',
    ['enter_amount'] = 'Enter the amount to be charged',
    ['enter_description'] = 'Product/service description (optional)',
    ['confirm_charge'] = 'Confirm Charge',
    
    -- Customer Menu Options
    ['pay_cash'] = 'Pay with Cash',
    ['pay_bank'] = 'Pay with Card',
    ['payment_info'] = 'Payment Information',
    ['available_cash'] = 'Available cash: $%s',
    ['available_bank'] = 'Available in bank: $%s',
    ['cancel'] = 'Cancel',
    
    -- Success Notifications
    ['charge_registered'] = 'Charge of $%s registered at the cashier',
    ['payment_successful'] = 'Payment completed successfully!',
    ['payment_received'] = 'Payment received: $%s from %s',
    ['commission_received'] = 'Commission received: $%s',
    ['charge_cleared'] = 'Charge removed from system',
    
    -- Error Notifications
    ['invalid_amount'] = 'Invalid amount',
    ['no_charge_pending'] = 'No pending charges at this cashier',
    ['insufficient_cash'] = 'Insufficient cash',
    ['insufficient_bank'] = 'Insufficient bank balance',
    ['charge_expired'] = 'Charge expired and was removed from system',
    ['charge_not_found'] = 'Charge not found',
    ['not_authorized'] = 'You are not authorized to use this cashier',
    ['too_far_from_cashier'] = 'You are too far from the cashier',
    ['no_active_charge'] = 'No active charge found for your company',
    
    -- Target Interactions
    ['target_register_charge'] = 'Register Charge',
    ['target_make_payment'] = 'Make Payment',
    ['target_cashier'] = 'Cash Register',
    
    -- Descriptions
    ['amount_description'] = 'Amount to be charged from customer',
    ['cash_payment_desc'] = 'Pay with cash in hand',
    ['bank_payment_desc'] = 'Pay with card/bank account',
    ['charge_info_desc'] = 'Amount: $%s | %s',
    
    -- Confirmations
    ['confirm_payment'] = 'Confirm payment of $%s?',
    ['confirm_payment_method'] = 'Do you want to pay $%s with %s?',
    
    -- Status
    ['pending_charge'] = 'Pending Charge',
    ['charge_amount_label'] = 'Amount: $%s',
    ['charge_description_label'] = 'Description: %s',
    ['cashier_name'] = 'Employee: %s',
    
    -- Commands
    ['clear_charge_help'] = 'Clear active charge from your company',
    ['charge_cleared_success'] = 'Charge removed successfully',
    ['no_permission'] = 'You do not have permission to use this command',
}