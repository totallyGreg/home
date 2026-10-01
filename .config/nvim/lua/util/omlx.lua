-- oMLX model profiles, read from pi's model registry so there is one source of truth.
local M = {}

local MODELS_JSON = vim.fn.expand("~/.pi/agent/models.json")

---@return { id: string, name: string }[]
function M.profiles()
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(MODELS_JSON), "\n"))
  end)
  local models = ok and vim.tbl_get(data, "providers", "omlx", "models")
  if not models then
    vim.notify("No omlx models found in " .. MODELS_JSON, vim.log.levels.ERROR)
    return {}
  end
  return models
end

---Prompt for a profile, then call `on_choice` with its model id.
---@param prompt string
---@param on_choice fun(id: string)
function M.pick(prompt, on_choice)
  vim.ui.select(M.profiles(), {
    prompt = prompt,
    format_item = function(m)
      return m.name
    end,
  }, function(m)
    if m then
      on_choice(m.id)
    end
  end)
end

return M
