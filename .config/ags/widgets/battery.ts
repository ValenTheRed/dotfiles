import { WHITESUR_ICON_SIZE } from "constants";
import Gtk from "types/@girs/gtk-3.0/gtk-3.0";

const battery = await Service.import("battery");

const Icon = Widget.Icon({
    class_name: "battery-icon",
    size: WHITESUR_ICON_SIZE.DEFAULT,
    icon: battery.bind("icon_name"),
});

export default Widget.Button({
    class_name: "battery status-widget",
    always_show_image: true,
    image: Icon,
    image_position: Gtk.PositionType.RIGHT,
    label: battery.bind("percent").as((p) => String(p) + "%"),
});
