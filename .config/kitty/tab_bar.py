"""draw kitty tab"""

import datetime

from kitty.fast_data_types import Screen, get_options
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

    def draw_active_tab_decorator(symbol: str):
        screen.cursor.bg, screen.cursor.fg = (fg, bg)
        screen.draw(symbol)
        screen.cursor.bg, screen.cursor.fg = (bg, fg)

    def draw_tab_separator():
        screen.cursor.bg, screen.cursor.fg = (
            opts.inactive_tab_background.rgb,
            opts.inactive_tab_foreground.rgb,
        )
        screen.draw(TAB_SEPARATOR)
        screen.cursor.bg, screen.cursor.fg = (bg, fg)

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
        draw_tab_separator()

    return screen.cursor.x
