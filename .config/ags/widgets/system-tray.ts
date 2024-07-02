import { WHITESUR_ICON_SIZE } from "constants";
import { TrayItem } from "types/service/systemtray";

const systemtray = await Service.import("systemtray");

const SysTrayItem = (item: TrayItem) =>
    Widget.Button({
        setup: () => {
            print(item.icon)
        },
        class_name: "system-tray-item status-widget",
        image: Widget.Icon({ size: WHITESUR_ICON_SIZE.DEFAULT }).bind(
            "icon",
            item,
            "icon",
        ),
        tooltipMarkup: item.bind("tooltip_markup"),
        onPrimaryClick: (_, event) => item.activate(event),
        onSecondaryClick: (_, event) => item.openMenu(event),
    })

export default Widget.Box({
    class_name: "system-tray",
    children: systemtray.bind("items").as((i) => i.map(SysTrayItem)),
});
