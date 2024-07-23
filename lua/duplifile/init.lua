local M = {}

function M.duplicate_file(path)
  vim.cmd('edit ' .. path)
  local buf = vim.api.nvim_get_current_buf()
  local relative = vim.fn.fnamemodify(path, ":.:h")
  local extension = vim.fn.fnamemodify(path, ":e")

  local dir = vim.fn.input("Choose directory: ", relative)
  local name = vim.fn.input("Rename file: ")

  if name == '' then
    print("Please select a file name")
    return
  end

  local new_path = dir .. '/' .. name .. '.' .. extension
  vim.fn.mkdir(vim.fn.fnamemodify(new_path, ":h"), "p")

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.cmd("e " .. new_path)
  local new_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, lines)
  vim.cmd("write")
  print("File has been duplicated at: " .. new_path)
end

function M.duplicate()
  local telescope = require('telescope.builtin')
  telescope.find_files({
    prompt_title = "Pick File",
    attach_mappings = function (_, map)
      map('i', '<CR>', function(prompt_bufnr)
	local file = require('telescope.actions.state').get_selected_entry()
	require('telescope.actions').close(prompt_bufnr)
	M.duplicate_file(file.path)
      end)
      return true
    end
  })
end

function M.duplicate_active()
  M.duplicate_file(vim.api.nvim_buf_get_name(0))
end

vim.api.nvim_create_user_command(
  "DupliFile",
  function()
    M.duplicate()
  end,
  { nargs = 0 }
)

vim.api.nvim_create_user_command(
  "DupliFileActive",
  function()
    M.duplicate_active()
  end,
  { nargs = 0 }
)

vim.api.nvim_set_keymap('n', '<leader>df', ':DupliFile<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>da', ':DupliFileActive<CR>', { noremap = true, silent = true })

return M
