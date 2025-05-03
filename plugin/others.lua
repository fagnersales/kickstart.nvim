local function go_to_file_in_comment()
  local line = vim.api.nvim_get_current_line()
  local pattern = '"(.-)"'
  local match = string.match(line, pattern)

  if match then
    local path = match
    -- Get the directory of the current buffer
    local current_file_dir = vim.fn.fnamemodify(vim.fn.bufname '%', ':h')
    -- Construct the full path
    local full_path = current_file_dir .. '/' .. path

    -- Check if the file exists and is readable
    if vim.fn.filereadable(full_path) == 1 then
      -- Save the current working directory
      local old_cwd = vim.fn.getcwd()
      -- Change to the directory of the current file (optional)
      vim.cmd('cd ' .. current_file_dir)
      -- Open the file
      vim.cmd('edit ' .. path)
      -- Change back to the original working directory
      vim.cmd('cd ' .. old_cwd)
    else
      print('File does not exist: ' .. full_path)
    end
  else
    print 'No recognized file path in comment on this line.'
  end
end

vim.keymap.set('n', '<leader>gfc', go_to_file_in_comment, { desc = '[G]o to [F]ile in [C]omment' })
