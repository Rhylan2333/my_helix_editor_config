# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import os.path
import subprocess
from libqtile import hook
from libqtile.utils import send_notification

# /home/caicai/.local/pipx/venvs/qtile/bin/python3 -m pip install psutil
import psutil

# sudo apt install libiw-dev
# /home/caicai/.local/pipx/venvs/qtile/bin/python3 -m pip install iwlib
import iwlib

# /home/caicai/.local/pipx/venvs/qtile/bin/python3 -m pip install pulsectl_asyncio
# 启动蓝牙按钮
import pulsectl_asyncio

# /home/caicai/.local/pipx/venvs/qtile/bin/python3 -m pip install pyxdg
# import pyxdg

# https://wiki.debian.org/CpuFrequencyScaling
# sudo aptitude install cpupower-gui cpufrequtils sysfsutils


@hook.subscribe.startup_complete
def run_every_startup():
    home_dir = os.path.expanduser("~")
    subprocess.Popen([home_dir + "/.config/qtile/autostart.sh"])
    send_notification("qtile", "Startup complete!")


# 当悬浮的窗口获得焦点，自动挪到最前面
@hook.subscribe.client_focus
def bringWindowFront(client_window):
    # 如果是悬浮窗口
    if client_window.floating:
        client_window.bring_to_front()


mod = "mod4"
terminal = guess_terminal("wezterm")

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 5):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

my_groups = [
    "1",
    "2",
    "3",
]

groups = [Group(i) for i in my_groups]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(
        border_focus="#66b700",
        border_focus_stack="#66b700",
        border_normal="#565656",
        border_normal_stack="#565656",
        border_on_single=True,
        border_width=5,
        fair=True,
        margin=5,
        margin_on_single=5,
        single_border_width=2,
    ),
    layout.Floating(
        border_focus="#1490a8",
        border_normal="#8c9bb8",
        border_width=2,
    ),
    layout.Max(
        border_focus="#c6813c",
        border_normal="#d1c384",
        border_width=1,
    ),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font Mono",
    fontsize=24,
    padding=5,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper=os.path.join(
            os.path.expanduser("~"), "图片/blackmyth_wukong_wallpaper_035.jpg"
        ),
        wallpaper_mode="fill",
        bottom=bar.Bar(
            [
                widget.CheckUpdates(
                    colour_have_updates="#2f0c2c",
                    colour_no_updates="#312d2e",
                    # custom_command="apt list --upgradable",
                    distro="Debian",
                    update_interval=3600,
                ),
                widget.CurrentLayoutIcon(
                    foreground="#f8f3ed",
                    background="#c4c7cc",
                ),
                widget.TextBox(
                    "WindowCount:",
                    fontsize=16,
                    foreground="#312d2e",
                ),
                widget.WindowCount(
                    fontsize=16,
                    foreground="#312d2e",
                ),
                widget.TextBox(
                    "🌦️",
                    fontsize=24,
                    foreground="#312d2e",
                ),
                widget.GroupBox(
                    active="#99db05",
                    highlight_method="block",
                    inactive="#c4c7cc",
                    foreground="#f8f3ed",
                    fontsize=16,
                    this_current_screen_border="#95613c",
                    this_screen_border="#95613c",
                ),
                widget.Prompt(
                    background="#f8f3ed",
                    cursor_color="#312d2e",
                    fontsize=16,
                    foreground="#2f0c2c",
                    visual_bell_color="#f71602",
                ),
                widget.Clipboard(
                    borderwidth=20,
                    fontsize=12,
                    margin=1,
                    foreground="#3a3539",
                    scroll=True,
                    scroll_clear=True,
                    scroll_delay=1,
                    scroll_fixed_width=True,
                    scroll_hide=True,
                ),
                widget.TaskList(
                    background="#f8f3ed",
                    border="#99db05",
                    fontsize=12,
                    foreground="#312d2e",
                    highlight_method="block",
                    padding=6,
                ),
                # widget.WindowName(
                #     foreground="#312d2e",
                #     fontsize=14,
                # ),
                widget.Chord(
                    chords_colors={
                        "launch": ("#f40808", "#f8f3ed"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                widget.TextBox(
                    "CPU:",
                    fontsize=16,
                    foreground="#312d2e",
                ),
                widget.ThermalSensor(
                    fontsize=16,
                    foreground="#312d2e",
                    foreground_alert="#f71602",
                    tag_sensor="Tctl",
                    update_interval=5,
                ),
                # widget.ThermalZone(
                #     fgcolor_normal="#5a8d48",
                #     fgcolor_crit="#fc6e02",
                #     fgcolor_high="#f71602",
                #     fontsize=16,
                #     foreground="#312d2e",
                # ),
                widget.CPUGraph(
                    border_color="#f8f3ed",
                    fill_color="#f40808",
                    graph_color="#f7def4",
                    line_width=1,
                ),
                widget.TextBox(
                    "Memory:",
                    fontsize=16,
                    foreground="#312d2e",
                ),
                widget.MemoryGraph(
                    border_color="#f8f3ed",
                    fill_color="#ceaa14",
                    graph_color="#edd044",
                    line_width=1,
                ),
                widget.TextBox(
                    "Net:",
                    fontsize=16,
                    foreground="#312d2e",
                ),
                widget.NetGraph(
                    border_color="#f8f3ed",
                    type="box",
                ),
                # widget.TextBox(
                #     "PulseVolume:",
                #     fontsize=16,
                #     foreground="#312d2e",
                # ),
                # # widget.Bluetooth(
                # #     foreground="#312d2e",
                # # ),
                # widget.PulseVolume(
                #     fontsize=16,
                #     volume_app="/usr/bin/kmix",
                #     foreground="#312d2e",
                # ),
                # widget.Sep(
                #     foreground="#312d2e",
                #     linewidth=2,
                #     padding=1,
                #     size_percent=61.8
                # ),
                # widget.She(),
                widget.WidgetBox(
                    background="#c4c7cc",
                    close_button_location="right",
                    fontsize=18,
                    foreground="#f8f3ed",
                    text_closed="<|",
                    text_open="|>",
                    widgets=[
                        widget.TextBox(
                            "Volume:",
                            fontsize=16,
                            foreground="#312d2e",
                        ),
                        widget.Volume(
                            fontsize=16,
                            volume_app="/usr/bin/kmix",
                            foreground="#312d2e",
                        ),
                    ],
                ),
                # widget.StatusNotifier(
                #     background="#312d2e",
                # ),
                # widget.Wlan(
                #     background="#000000",
                # ),
                # 很有用的功能，待实现
                # widget.LaunchBar(
                #     background="#312d2e",
                # ),
                widget.Systray(
                    foreground="#312d2e",
                    background="#f8f3ed",
                    icon_size=24,
                    padding=5,
                ),
                widget.Clock(
                    format="%A %Y-%m-%d %H:%M",
                    fontsize=16,
                    foreground="#312d2e",
                ),
                widget.Image(
                    filename="~/图片/我的1x1.jpg",
                    margin=1,
                ),
            ],
            36,
            background="#f8f3ed",
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = True
floats_kept_above = True
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
