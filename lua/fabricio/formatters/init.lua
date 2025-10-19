local M = {}

-- Registry of custom formatters
local formatters = {}

-- Register a formatter configuration
function M.register(config)
  if not config.filetype or not config.command then
    error("Formatter config must have 'filetype' and 'command' fields")
  end
  
  formatters[config.filetype] = {
    command = config.command,
    name = config.name or config.command,
    args = config.args or {},
  }
end

-- Format the current buffer using registered custom formatter
function M.format()
  local filetype = vim.bo.filetype
  local formatter = formatters[filetype]
  
  if not formatter then
    return false
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local input = table.concat(lines, "\n")
  
  -- Build command with args if present
  local cmd = formatter.command
  if #formatter.args > 0 then
    cmd = cmd .. " " .. table.concat(formatter.args, " ")
  end
  
  local result = vim.fn.system(cmd, input)
  
  if vim.v.shell_error == 0 then
    local output_lines = vim.split(result, "\n")
    -- Remove trailing empty line if present
    if output_lines[#output_lines] == "" then
      table.remove(output_lines)
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, output_lines)
    print("Formatted with " .. formatter.name)
    return true
  else
    print(formatter.name .. " error: " .. result)
    return false
  end
end

-- Auto-register all formatters in this directory
function M.setup()
  local formatters_dir = vim.fn.stdpath('config') .. '/lua/fabricio/formatters'
  local formatter_files = vim.fn.glob(formatters_dir .. '/*.lua', false, true)
  
  for _, file in ipairs(formatter_files) do
    local filename = vim.fn.fnamemodify(file, ':t:r')
    -- Skip init.lua itself
    if filename ~= 'init' then
      local ok, config = pcall(require, 'fabricio.formatters.' .. filename)
      if ok and type(config) == 'table' and config.filetype then
        M.register(config)
      end
    end
  end
end

return M
