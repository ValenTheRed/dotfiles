import {
    DISABLED,
    ENABLED,
    GAMMA_CONTROL_ICONS,
    WHITESUR_ICON_SIZE,
} from "constants";

type IconType = typeof ENABLED | typeof DISABLED;

const Icon = (type: IconType) =>
    Widget.Icon({
        size: WHITESUR_ICON_SIZE.DEFAULT,
        icon:
            type === ENABLED
                ? GAMMA_CONTROL_ICONS.ENABLED
                : GAMMA_CONTROL_ICONS.DISABLED,
    });

export default Widget.Button({
    class_name: "gamma-control status-widget",
    on_clicked: (self) => {
        Utils.exec("pkill -SIGUSR1 wlsunset");
        if (self.tooltip_text === ENABLED) {
            self.image = Icon(DISABLED);
            self.tooltip_text = DISABLED;
        } else {
            self.image = Icon(ENABLED);
            self.tooltip_text = ENABLED;
        }
    },
    image: Icon(ENABLED),
    tooltip_text: ENABLED,
});
