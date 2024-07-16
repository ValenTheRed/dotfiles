import { GAMMA_CONTROL, WHITESUR_ICON_SIZE } from "constants";

const Icon = (name: string) =>
    Widget.Icon({
        size: WHITESUR_ICON_SIZE.DEFAULT,
        icon: name,
    });

export default Widget.Button({
    class_name: "gamma-control status-widget",
    on_clicked: (self) => {
        Utils.exec("pkill -SIGUSR1 wlsunset");
        switch (self.tooltip_text) {
            case GAMMA_CONTROL.LABELS.AUTO_TEMP: {
                self.tooltip_text = GAMMA_CONTROL.LABELS.LOW_TEMP;
                self.image = Icon(GAMMA_CONTROL.ICONS.LOW_TEMP);
                break;
            }
            case GAMMA_CONTROL.LABELS.LOW_TEMP: {
                self.tooltip_text = GAMMA_CONTROL.LABELS.HIGH_TEMP;
                self.image = Icon(GAMMA_CONTROL.ICONS.HIGH_TEMP);
                break;
            }
            case GAMMA_CONTROL.LABELS.HIGH_TEMP: {
                self.tooltip_text = GAMMA_CONTROL.LABELS.AUTO_TEMP;
                self.image = Icon(GAMMA_CONTROL.ICONS.AUTO_TEMP);
                break;
            }
        }
    },
    image: Icon(GAMMA_CONTROL.ICONS.AUTO_TEMP),
    tooltip_text: GAMMA_CONTROL.LABELS.AUTO_TEMP,
});
