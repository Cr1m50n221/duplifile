local M = {}

-- Default keybindings.
local default = {
  duplicate = "<leader>df",
  duplicate_active = "<leader>da"
}

M.config = default

-- Allows user to change default keybindings.
function M.setup(user)
  M.config = vim.tbl_extend("force", default, user or {})
end

-- Main function that duplicates files.
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

  vim.schedule(function()
    print("File has been duplicated at: " .. new_path)
  end)
end

-- Duplicates the file chosen by the user. Requires telescope.
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

-- Duplicates the current file.
function M.duplicate_active()
  M.duplicate_file(vim.api.nvim_buf_get_name(0))
end

-- Create "DupliFile" command.
vim.api.nvim_create_user_command(
  "DupliFile",
  function()
    M.duplicate()
  end,
  { nargs = 0 }
)

-- Create "DupliFileActive" command.
vim.api.nvim_create_user_command(
  "DupliFileActive",
  function()
    M.duplicate_active()
  end,
  { nargs = 0 }
)

-- Plugin keybindings.
function M.keybindings()
  vim.api.nvim_set_keymap('n', M.config.duplicate, ':DupliFile<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', M.config.duplicate_active, ':DupliFileActive<CR>', { noremap = true, silent = true })
end

M.keybindings()

return M
