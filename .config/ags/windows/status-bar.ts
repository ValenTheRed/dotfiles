import { WIDGET_SPACING } from "constants";
import {
    Date,
    Battery,
    Workspace,
    VolumeIndicator,
    SystemTray,
    GammaControl,
} from "widgets";

export default (monitor: number) =>
    Widget.Window({
        class_name: "panel",
        monitor,
        name: "panel",
        anchor: ["top", "left", "right"],
        exclusivity: "exclusive",
        layer: "top",
        child: Widget.CenterBox({
            startWidget: Widget.Box({
                class_name: "start-widget",
                hpack: "start",
                children: [Workspace],
            }),
            endWidget: Widget.Box({
                class_name: "end-widget",
                hpack: "end",
                spacing: WIDGET_SPACING,
                children: [
                    SystemTray,
                    GammaControl,
                    VolumeIndicator,
                    Battery,
                    Date,
                ],
            }),
        }),
    });
