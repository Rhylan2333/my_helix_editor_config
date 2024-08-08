local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.background = {
  {
    source = { File = '/home/caicai/Pictures/d5e286_4_makeup_4k.jpg' },
    horizontal_align = 'Center',
    hsb = { brightness = 0.2 },
    opacity = 1,
    vertical_align = 'Middle',
  },
}

config.colors = {
  ansi = { '#282433', '#e965a5', '#b1f2a7', '#ebde76', '#b1baf4', '#e192ef', '#b3f4f3', '#eee9fc' },
  brights = { 'rgba(209, 194, 211, 0.5)', '#e965a5', '#b1f2a7', '#ebde76', '#b1baf4', '#e192ef', '#b3f4f3', '#eee9fc' },
  compose_cursor = '#ebde76',
  cursor_bg = 'rgba(27,167,132,0.5)',
  cursor_border = '#1ba784',
  cursor_fg = 'rgba(209,194,211,0.5)',
  scrollbar_thumb = '#d1c2d3',
  selection_bg = 'rgba(209,194,211,0.5)',
  selection_fg = 'None',
  split = '#1ba784',
  tab_bar = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = '#4f383e',

    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      bg_color = '#bdaead',
      -- The color of the text for the tab
      fg_color = '#4c1f24',

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = 'Normal',

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      underline = 'None',

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      italic = true,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      strikethrough = false,
    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = '#302f4b',
      fg_color = '#b89485',
      italic = false,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = '#5a1216',
      fg_color = '#d8e3e7',
      italic = false,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
    },

    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = '#2d0c13',
      fg_color = '#7a7374',
      italic = false,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
      bg_color = '#5a1216',
      fg_color = '#d8e3e7',
      italic = false,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab_hover`.
    },
  },
}

-- config.color_scheme = 'Cupcake (base16)'
-- config.color_scheme = 'synthwave-everything'
-- config.color_scheme = 'Bamboo Multiplex'
config.color_scheme = 'hardhacker'
config.color_scheme_dirs = { '$HOME/.config/wezterm/colors' }
config.default_prog = { '/usr/bin/fish' }

config.enable_scroll_bar = true

config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font Mono',
  'Noto Sans CJK SC',
}

-- -- The filled in variant of the ◖ symbol
-- local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick

-- -- The filled in variant of the ◗ symbol
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick

-- -- This function returns the suggested title for a tab.
-- -- It prefers the title that was set via `tab:set_title()`
-- -- or `wezterm cli set-tab-title`, but falls back to the
-- -- title of the active pane in that tab.
-- function tab_title(tab_info)
--   local title = tab_info.tab_title
--   -- if the tab title is explicitly set, take that
--   if title and #title > 0 then
--     return title
--   end
--   -- Otherwise, use the title from the active pane
--   -- in that tab
--   return tab_info.active_pane.title
-- end

-- wezterm.on(
--   'format-tab-title',
--   function(tab, tabs, panes, config, hover, max_width)
--     local edge_background = '#ffffff'
--     local background = '#1b1032'
--     local foreground = '#808080'

--     if tab.is_active then
--       background = '#2b2042'
--       foreground = '#c0c0c0'
--     elseif hover then
--       background = '#3b3052'
--       foreground = '#909090'
--     end

--     local edge_foreground = background

--     local title = tab_title(tab)

--     -- ensure that the titles fit in the available space,
--     -- and that we have room for the edges.
--     title = wezterm.truncate_right(title, max_width - 1)

--     return {
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_LEFT_ARROW },
--       { Background = { Color = background } },
--       { Foreground = { Color = foreground } },
--       { Text = title },
--       { Background = { Color = edge_background } },
--       { Foreground = { Color = edge_foreground } },
--       { Text = SOLID_RIGHT_ARROW },
--     }
--   end
-- )

config.hide_tab_bar_if_only_one_tab = true
config.text_background_opacity = 0.8

return config
