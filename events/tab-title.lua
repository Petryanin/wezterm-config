local wezterm = require('wezterm')
local colors = require('colors.custom')

-- Inspired by https://github.com/wez/wezterm/discussions/628#discussioncomment-1874614
local GLYPH_SEMI_CIRCLE_LEFT = '' -- nf.ple_left_half_circle_thick
local GLYPH_SEMI_CIRCLE_RIGHT = '' -- nf.ple_right_half_cirlce_thick
local GLYPH_CIRCLE = '●'
local GLYPH_ADMIN = '󰞀' -- nf.md_shield_half_full

local M = {}

local __cells__ = {}

local colors = {
   default = { bg = colors.tab_bar.inactive_tab.bg_color, fg = colors.tab_bar.inactive_tab.fg_color, },
   is_active = { bg = colors.tab_bar.active_tab.bg_color, fg = colors.tab_bar.active_tab.fg_color, },
   hover = { bg = colors.tab_bar.inactive_tab_hover.bg_color, fg = colors.tab_bar.inactive_tab_hover.fg_color, },
   unseen_output_glyph = colors.ansi[7],
}

local _get_basename = function (s)
   local a = string.gsub(s, '(.*[/\\])(.*)', '%2')
   return a:gsub('%.exe$', '')
end

local _get_title = function (tab_index, process_name, base_title, max_width, inset, has_unseen_output)
   local title

   if has_unseen_output then
      inset = inset + 2
   end

   base_title = _get_basename(base_title)
   if process_name:len() > 0 then
      title = tab_index .. ': ' .. process_name .. ' ' .. base_title
   else
      title = tab_index .. ': ' .. base_title
   end

   if title:len() > max_width - inset then
      local diff = title:len() - max_width + inset
      title = wezterm.truncate_right(title, title:len() - diff)
   end

   return title
end

local _check_if_admin = function (p)
   if p:match('^Administrator: ') then
      return true
   end
   return false
end

---@param fg string
---@param bg string
---@param attribute table
---@param text string
local _push = function (bg, fg, attribute, text)
   table.insert(__cells__, { Background = { Color = bg } })
   table.insert(__cells__, { Foreground = { Color = fg } })
   table.insert(__cells__, { Attribute = attribute })
   table.insert(__cells__, { Text = text })
end

M.setup = function ()
   wezterm.on('format-tab-title', function (tab, _tabs, _panes, _config, hover, max_width)
      __cells__ = {}

      local has_unseen_output = false
      for _, pane in ipairs(tab.panes) do
         if pane.has_unseen_output then
            has_unseen_output = true
            break
         end
      end

      local bg
      local fg
      local process_name = _get_basename(tab.active_pane.foreground_process_name)
      local is_admin = _check_if_admin(tab.active_pane.title)
      local title = _get_title(tab.tab_index + 1, process_name, tab.active_pane.title, max_width,
      (is_admin and 6 or 4), has_unseen_output)

      if tab.is_active then
         bg = colors.is_active.bg
         fg = colors.is_active.fg
      elseif hover then
         bg = colors.hover.bg
         fg = colors.hover.fg
      else
         bg = colors.default.bg
         fg = colors.default.fg
      end


      -- Left semi-circle
      _push(fg, bg, { Intensity = 'Bold' }, GLYPH_SEMI_CIRCLE_LEFT)

      -- Admin Icon
      if is_admin then
         _push(bg, fg, { Intensity = 'Bold' }, ' ' .. GLYPH_ADMIN)
      end

      -- Title
      _push(bg, fg, { Intensity = 'Bold' }, ' ' .. title)

      -- Unseen output alert
      if has_unseen_output then
         _push(bg, colors.unseen_output_glyph, { Intensity = 'Bold' }, ' ' .. GLYPH_CIRCLE)
      end

      -- Right padding
      _push(bg, fg, { Intensity = 'Bold' }, ' ')

      -- Right semi-circle
      _push(fg, bg, { Intensity = 'Bold' }, GLYPH_SEMI_CIRCLE_RIGHT)

      return __cells__
   end)
end

return M
