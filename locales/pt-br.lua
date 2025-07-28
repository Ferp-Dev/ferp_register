-- Verificar se Locales existe, se não criar
if not Locales then
    Locales = {}
end

Locales['pt-br'] = {
    ['cashier_notify_title'] = 'Caixa',
    ['cashier_debug_payment_processed'] = 'Pagamento processado: %s pagou $%s para %s (Empresa: %s)',
    ['cashier_debug_charge_expired'] = 'Cobrança expirada - %s',
    ['cashier_error_oxlib_unavailable'] = 'ox_lib não está disponível!',
    ['cashier_debug_opening_menu'] = 'Abrindo menu principal para: %s',
    ['cashier_error_opening_menu'] = 'Erro ao abrir menu principal: %s',
    ['error_opening_menu'] = 'Erro ao abrir menu',
    ['error'] = 'Erro',
    ['cashier_debug_opening_charge_menu'] = 'Abrindo menu de cobrança para: %s',
    ['cashier_error_opening_input'] = 'Erro ao abrir inputDialog: %s',
    ['cashier_debug_requesting_payment_info'] = 'Solicitando informações de pagamento para: %s',
    ['cashier_error_player_data_unavailable'] = 'Dados do jogador não disponíveis',
    ['cashier_error_showing_payment_menu'] = 'Erro ao mostrar menu de pagamento: %s',
    ['cashier_error_showing_confirm_dialog'] = 'Erro ao mostrar dialog de confirmação: %s',
    ['cashier_debug_processing_payment'] = 'Processando pagamento: %s via %s',
    ['cashier_debug_payment_cancelled'] = 'Pagamento cancelado',
    ['cancel_charge_confirm'] = 'Cancelar cobrança pendente?',
    -- Títulos dos Menus
    ['cashier_menu'] = 'Caixa Registradora',
    ['payment_menu'] = 'Efetuar Pagamento',
    ['charge_menu'] = 'Registrar Cobrança',
    
    -- Opções do Menu do Funcionário
    ['register_charge'] = 'Registrar Cobrança',
    ['charge_amount'] = 'Valor da Cobrança',
    ['charge_description'] = 'Descrição',
    ['enter_amount'] = 'Digite o valor a ser cobrado',
    ['enter_description'] = 'Descrição do produto/serviço (opcional)',
    ['confirm_charge'] = 'Confirmar Cobrança',
    
    -- Opções do Menu do Cliente
    ['pay_cash'] = 'Pagar em Dinheiro',
    ['pay_bank'] = 'Pagar no Cartão',
    ['payment_info'] = 'Informações do Pagamento',
    ['available_cash'] = 'Disponível em dinheiro: $%s',
    ['available_bank'] = 'Disponível no banco: $%s',
    ['cancel'] = 'Cancelar',
    
    -- Notificações de Sucesso
    ['charge_registered'] = 'Cobrança de $%s registrada no caixa',
    ['payment_successful'] = 'Pagamento realizado com sucesso!',
    ['payment_received'] = 'Pagamento recebido: $%s de %s',
    ['commission_received'] = 'Comissão recebida: $%s',
    ['charge_cleared'] = 'Cobrança removida do sistema',
    
    -- Notificações de Erro
    ['invalid_amount'] = 'Valor inválido',
    ['no_charge_pending'] = 'Nenhuma cobrança pendente neste caixa',
    ['insufficient_cash'] = 'Dinheiro insuficiente',
    ['insufficient_bank'] = 'Saldo bancário insuficiente',
    ['charge_expired'] = 'Cobrança expirou e foi removida do sistema',
    ['charge_not_found'] = 'Cobrança não encontrada',
    ['not_authorized'] = 'Você não tem autorização para usar este caixa',
    ['too_far_from_cashier'] = 'Você está muito longe do caixa',
    ['no_active_charge'] = 'Nenhuma cobrança ativa encontrada para sua empresa',
    
    -- Interações Target
    ['target_register_charge'] = 'Registrar Cobrança',
    ['target_make_payment'] = 'Efetuar Pagamento',
    ['target_cashier'] = 'Caixa Registradora',
    
    -- Descrições
    ['amount_description'] = 'Valor a ser cobrado do cliente',
    ['cash_payment_desc'] = 'Pagar com dinheiro em mãos',
    ['bank_payment_desc'] = 'Pagar com cartão/conta bancária',
    ['charge_info_desc'] = 'Valor: $%s | %s',
    
    -- Confirmações
    ['confirm_payment'] = 'Confirmar pagamento de $%s?',
    ['confirm_payment_method'] = 'Deseja pagar $%s em %s?',
    
    -- Status
    ['pending_charge'] = 'Cobrança Pendente',
    ['charge_amount_label'] = 'Valor: $%s',
    ['charge_description_label'] = 'Descrição: %s',
    ['cashier_name'] = 'Funcionário: %s',
    
    -- Comandos
    ['clear_charge_help'] = 'Limpar cobrança ativa da sua empresa',
    ['charge_cleared_success'] = 'Cobrança removida com sucesso',
    ['no_permission'] = 'Você não tem permissão para usar este comando',
}