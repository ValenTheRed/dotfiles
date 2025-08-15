"""draw kitty tab"""

import datetime
import os
import pathlib
import subprocess
from typing import Callable

from kitty import rgb
from kitty.fast_data_types import Screen, add_timer, get_boss, get_options
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    draw_title,
)

opts = get_options()

ROUNDED_POWERLINE_LEFT = ""
ROUNDED_POWERLINE_RIGHT = ""
ACTIVE_WINDOW_INDICATOR = " "
INACTIVE_WINDOW_INDICATOR = " "
TAB_SEPARATOR = " · "
WINDOW_ZOOMED = "  "
CALENDAR = " "
CLOCK = " "


def draw_right_status(
    screen: Screen,
    set_inactive: Callable[[], None],
    restore: Callable[[], None],
):
    components: list[str] = []
    try:
        xdg_config_home = os.getenv("XDG_CONFIG_HOME")
        low_battery = subprocess.check_output(
            pathlib.Path(f"{xdg_config_home}/tmux/low_battery")
            .resolve(strict=True)
            .absolute(),
            universal_newlines=True,
        ).strip()
        battery = subprocess.check_output(
            pathlib.Path(f"{xdg_config_home}/tmux/battery")
            .resolve(strict=True)
            .absolute(),
            universal_newlines=True,
        ).strip()
        components.append(" ".join((low_battery, battery)).strip())
    except BaseException:
        pass
    components.append(
        CALENDAR + datetime.date.today().strftime("%a %-d %b"),
    )
    components.append(
        CLOCK + datetime.datetime.now().strftime("%-I:%M %p"),
    )
    right_status = TAB_SEPARATOR.join(components)
    screen.cursor.x = screen.columns - len(right_status)

    set_inactive()
    if components:
        screen.cursor.fg = rgb.color_names["orange"].rgb
        screen.draw(components[0])
        screen.draw(TAB_SEPARATOR)
        set_inactive()
        screen.draw(TAB_SEPARATOR.join(components[1:]))
    else:
        screen.draw(right_status)
    restore()


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    bg, fg = (screen.cursor.bg, screen.cursor.fg)

    def swap():
        screen.cursor.bg, screen.cursor.fg = (fg, bg)

    def set_inactive():
        screen.cursor.bg, screen.cursor.fg = (
            opts.inactive_tab_background.rgb,
            opts.inactive_tab_foreground.rgb,
        )
        screen.cursor.bold, screen.cursor.italic = opts.inactive_tab_font_style

    def restore():
        screen.cursor.bg, screen.cursor.fg = (bg, fg)
        screen.cursor.bold, screen.cursor.italic = opts.active_tab_font_style

    def draw_active_tab_decorator(symbol: str):
        swap()
        screen.draw(symbol)
        restore()

    if tab.is_active:
        draw_active_tab_decorator(ROUNDED_POWERLINE_LEFT)
        screen.draw(ACTIVE_WINDOW_INDICATOR)
        draw_title(draw_data, screen, tab, index, max_title_length)
        if tab.layout_name == "stack":
            screen.draw(WINDOW_ZOOMED)
        draw_active_tab_decorator(ROUNDED_POWERLINE_RIGHT)
    else:
        screen.draw(INACTIVE_WINDOW_INDICATOR)
        draw_title(draw_data, screen, tab, index, max_title_length)
        if tab.layout_name == "stack":
            screen.draw(WINDOW_ZOOMED)
    if not is_last:
        set_inactive()
        screen.draw(TAB_SEPARATOR)
        restore()

    if is_last:
        draw_right_status(screen, set_inactive, restore)
    return screen.cursor.x


# def redraw_tabs(timer_id: int | None):
#     tm = get_boss().active_tab_manager
#     if tm is not None:
#         tm.mark_tab_bar_dirty()


# _ = add_timer(redraw_tabs, 1, True)
