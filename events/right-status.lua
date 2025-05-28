local wezterm = require('wezterm')
local umath = require('utils.math')
local Cells = require('utils.cells')
local OptsValidator = require('utils.opts-validator')
local Colors = require('colors.custom')

---@alias Event.RightStatusOptions { date_format?: string }

---Setup options for the right status bar
local EVENT_OPTS = {}

---@type OptsSchema
EVENT_OPTS.schema = {
   {
      name = 'date_format',
      type = 'string',
      default = '%a %d %H:%M',
   },
}
EVENT_OPTS.validator = OptsValidator:new(EVENT_OPTS.schema)

local nf = wezterm.nerdfonts
local attr = Cells.attr

local M = {}

local ICON_DATE = nf.fa_calendar
local GLYPH_SCIRCLE_LEFT = nf.ple_left_half_circle_thick

---@type string[]
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
---@type string[]
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

---@type table<string, Cells.SegmentColors>
-- stylua: ignore
local colors = {
   date         = { fg = Colors.ansi[4], bg = Colors.scrollbar_thumb },
   battery      = { fg = Colors.ansi[3], bg = Colors.scrollbar_thumb },
   separator    = { fg = Colors.background, bg = Colors.scrollbar_thumb },
   scircle_left = { fg = Colors.scrollbar_thumb, bg = Colors.background },
}

local cells = Cells:new()

cells
    :add_segment('scircle_left', GLYPH_SCIRCLE_LEFT, colors.scircle_left)
    :add_segment('space', ' ', colors.space)
    :add_segment('date_icon', ICON_DATE .. '  ', colors.date, attr(attr.intensity('Bold')))
    :add_segment('date_text', '', colors.date, attr(attr.intensity('Bold')))
    :add_segment('separator', ' ', colors.separator)
    :add_segment('battery_icon', '', colors.battery)
    :add_segment('battery_text', '', colors.battery, attr(attr.intensity('Bold')))

---@return string, string, boolean
local function battery_info()
   -- ref: https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info.html

   local charge = ''
   local icon = ''
   local is_low = false

   for _, b in ipairs(wezterm.battery_info()) do
      local idx = umath.clamp(umath.round(b.state_of_charge * 10), 1, 10)
      charge = string.format('%.0f%%', b.state_of_charge * 100)

      if b.state == 'Charging' then
         icon = charging_icons[idx]
      else
         icon = discharging_icons[idx]
         if b.state_of_charge * 100 < 20 then
            is_low = true
         end
      end
   end

   return charge, icon .. ' ', is_low
end

---@param opts? Event.RightStatusOptions Default: {date_format = '%a %H:%M:%S'}
M.setup = function (opts)
   local valid_opts, err = EVENT_OPTS.validator:validate(opts or {})

   if err then
      wezterm.log_error(err)
   end

   wezterm.on('update-right-status', function (window, _pane)
      local battery_text, battery_icon, battery_low = battery_info()

      cells
          :update_segment_text('date_text', wezterm.strftime(valid_opts.date_format))
          :update_segment_text('battery_icon', battery_icon)
          :update_segment_text('battery_text', battery_text)
      if battery_low then
         cells
             :update_segment_colors('battery_icon', { fg = Colors.ansi[2], bg = Colors.scrollbar_thumb })
             :update_segment_colors('battery_text', { fg = Colors.ansi[2], bg = Colors.scrollbar_thumb })
      else
         cells
             :update_segment_colors('battery_icon', colors.battery)
             :update_segment_colors('battery_text', colors.battery)
      end

      window:set_right_status(
         wezterm.format(
            cells:render({
               'scircle_left', 'separator', 'date_icon', 'date_text', 'separator',
               'separator', 'battery_icon', 'battery_text', 'separator',
            })
         )
      )
   end)
end

return M
