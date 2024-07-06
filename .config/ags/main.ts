import "style";
import { WIDGET_SPACING } from "constants";
import battery from "daemons/battery";
import { Date, Battery, Workspace, VolumeIndicator, SystemTray } from "widgets";
import { VolumeControls } from "windows";

const Bar = (monitor: number) =>
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
                children: [SystemTray, VolumeIndicator, Battery, Date],
            }),
        }),
    });

App.config({
    onConfigParsed: () => {
        battery();
    },
    /// Ref: https://github.com/vinceliuice/WhiteSur-icon-theme
    iconTheme: "WhiteSur",
    style: "./style/style.css",
    windows: [Bar(0), VolumeControls(0)],
});
