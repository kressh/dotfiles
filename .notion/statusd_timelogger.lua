local timelogger_base_settings = {
  update_interval = 5*1000 -- 5 seconds
}

local timelogger_settings = timelogger_base_settings

local timelogger_timer

-- Read the active timelogger
local function read_timelogger_data ()
  local f = assert(io.popen("head -n 1 $HOME/tmp/timelogger.state | awk '{ print $1 }'"))
  local data = f:read("*all")
  f:close()
  return tonumber(data)
end

-- Write the current state to the statusbar:
local function inform_timelogger ()

  local timelogger = read_timelogger_data()

  statusd.inform("timelogger", tostring(math.floor(timelogger/60).." min"))
  statusd.inform("timelogger_hint", timelogger >= 25*60 and "critical" or "important")
end


-- Statusbar update loop:
local function update_timelogger ()
  inform_timelogger()
  timelogger_timer:set(timelogger_settings.update_interval, update_timelogger)
end


-- Run the script:
if statusd then
  -- we're a statusbar plugin:
  timelogger_settings = table.join(statusd.get_config("timelogger"), timelogger_base_settings)
  timelogger_timer = statusd.create_timer()
  update_timelogger()
end

-- vim: set ts=4 sw=4 expandtab