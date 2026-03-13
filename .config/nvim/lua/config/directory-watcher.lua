-- Filesystem watcher using libuv's fs_event API
-- Triggers buffer reloads instantly when files change on disk (e.g., from coding agents)

local M = {}

local watchers = {}
local debounce_timer = nil
local DEBOUNCE_MS = 100

local function trigger_reload()
  if debounce_timer then
    debounce_timer:stop()
  end
  debounce_timer = vim.uv.new_timer()
  debounce_timer:start(DEBOUNCE_MS, 0, vim.schedule_wrap(function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
    debounce_timer:stop()
    debounce_timer:close()
    debounce_timer = nil
  end))
end

function M.watch(path)
  path = path or vim.fn.getcwd()
  if watchers[path] then
    return
  end

  local handle = vim.uv.new_fs_event()
  if not handle then
    return
  end

  local ok, err = handle:start(path, { recursive = true }, function(err_msg, filename)
    if err_msg then
      return
    end
    if not filename then
      return
    end
    -- Skip hidden dirs other than .git, and common noisy paths
    if filename:match("^%.git/") and not filename:match("^%.git/index") then
      return
    end
    if filename:match("node_modules") or filename:match("%.swp$") or filename:match("~$") then
      return
    end
    trigger_reload()
  end)

  if ok then
    watchers[path] = handle
  else
    handle:close()
  end
end

function M.stop(path)
  path = path or vim.fn.getcwd()
  local handle = watchers[path]
  if handle then
    handle:stop()
    handle:close()
    watchers[path] = nil
  end
end

function M.stop_all()
  for p, handle in pairs(watchers) do
    handle:stop()
    handle:close()
    watchers[p] = nil
  end
end

-- Auto-start watching cwd, and restart when directory changes
M.watch()

vim.api.nvim_create_autocmd("DirChanged", {
  group = vim.api.nvim_create_augroup("DirectoryWatcher", { clear = true }),
  callback = function()
    M.stop_all()
    M.watch(vim.fn.getcwd())
  end,
  desc = "Restart filesystem watcher when cwd changes",
})

return M
