vim.api.nvim_create_user_command('ServerOnly', function()
  vim.api.nvim_put({
    'if (!i.guild || !i.member) {',
    'return Result.void(',
    'interactionReply(i.application_id, i.token, {',
    'content: "Você só pode usar este comando em servidores!",',
    '}),',
    ')',
    '}',
  }, 'l', true, true)
end, {})

vim.api.nvim_create_user_command('StoreOnly', function()
  vim.api.nvim_put({
    'if (i.guild?.id !== ConfigManager.main().guild.id) {',
    'return Result.void(',
    'interactionReply(i.application_id, i.token, {',
    'content: "Você só pode usar este comando no servidor da loja!",',
    '}),',
    ')',
    '}',
  }, 'l', true, true)
end, {})
