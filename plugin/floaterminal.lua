local state = {
  typecheck_floating = {
    win = -1,
  },
  main_floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}

  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = nil

  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { win = win, buf = buf }
end

local toggle_typecheck_terminal = function()
  if vim.api.nvim_win_is_valid(state.main_floating.win) then
    vim.api.nvim_win_hide(state.main_floating.win)
  end

  if not vim.api.nvim_win_is_valid(state.typecheck_floating.win) then
    state.typecheck_floating = create_floating_window()
    if vim.bo[state.typecheck_floating.buf].buftype ~= 'terminal' then
      vim.fn.termopen 'bun typecheck'
    end
  else
    vim.api.nvim_win_hide(state.typecheck_floating.win)
  end
end

local toggle_main_terminal = function()
  if vim.api.nvim_win_is_valid(state.typecheck_floating.win) then
    vim.api.nvim_win_hide(state.typecheck_floating.win)
  end

  if not vim.api.nvim_win_is_valid(state.main_floating.win) then
    state.main_floating = create_floating_window { buf = state.main_floating.buf }
    if vim.bo[state.main_floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.main_floating.win)
  end
  vim.cmd 'normal i'
end

vim.keymap.set({ 'n', 't' }, '<space>tt', toggle_main_terminal)
vim.keymap.set({ 'n', 't' }, '<space>tb', toggle_typecheck_terminal)
