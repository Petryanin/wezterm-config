local wezterm = require('wezterm')
local umath = require('utils.math')
local colors = require('colors.custom')

local nf = wezterm.nerdfonts
local M = {}

local discharging_icons = {
   nf.md_battery_10,
   nf.md_battery_20,
   nf.md_battery_30,
   nf.md_battery_40,
   nf.md_battery_50,
   nf.md_battery_60,
   nf.md_battery_70,
   nf.md_battery_80,
   nf.md_battery_90,
   nf.md_battery,
}
local charging_icons = {
   nf.md_battery_charging_10,
   nf.md_battery_charging_20,
   nf.md_battery_charging_30,
   nf.md_battery_charging_40,
   nf.md_battery_charging_50,
   nf.md_battery_charging_60,
   nf.md_battery_charging_70,
   nf.md_battery_charging_80,
   nf.md_battery_charging_90,
   nf.md_battery_charging,
}

local __cells__ = {} -- wezterm FormatItems (ref: https://wezfurlong.org/wezterm/config/lua/wezterm/format.html)

---@param text string
---@param icon string
---@param fg string
---@param bg string
local _push = function(text, icon, fg, bg)
   table.insert(__cells__, { Foreground = { Color = fg } })
   table.insert(__cells__, { Background = { Color = bg } })
   table.insert(__cells__, { Attribute = { Intensity = 'Bold' } })
   table.insert(__cells__, { Text = ' ' .. icon .. ' ' .. text .. ' ' })
end

local _set_date = function()
   local date = wezterm.strftime(' %a %d %H:%M')
   _push(date, nf.fa_calendar, colors.ansi[4], colors.scrollbar_thumb)
end

local _set_battery = function()
   -- ref: https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html

   local charge = ''
   local icon = ''
   local fg_color = colors.ansi[3]

   for _, b in ipairs(wezterm.battery_info()) do
      local idx = umath.clamp(umath.round(b.state_of_charge * 10), 1, 10)
      charge = string.format('%.0f%%', b.state_of_charge * 100)

      if b.state == 'Charging' then
         icon = charging_icons[idx]
      else
         icon = discharging_icons[idx]
         if b.state_of_charge * 100 < 20 then
            fg_color = colors.ansi[2]
         end
      end
   end

   if charge ~= '' then
      _push(charge, icon, fg_color, colors.scrollbar_thumb)
   end
end

M.setup = function()
   wezterm.on('update-right-status', function(window, _pane)
      __cells__ = {
         { Foreground = { Color = colors.scrollbar_thumb } },
         { Background = { Color = colors.background } },
         { Text = '' },
      }
      _set_date()
      _set_battery()

      window:set_right_status(wezterm.format(__cells__))
   end)
end

return M
