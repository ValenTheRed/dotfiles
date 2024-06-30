import "style";
import { Date, Battery, Workspace } from "widgets";

const Bar = (monitor: number) =>
    Widget.Window({
        monitor,
        name: "panel",
        anchor: ["top", "left", "right"],
        exclusivity: "exclusive",
        layer: "top",
        child: Widget.CenterBox({
            class_name: "panel",
            startWidget: Widget.Box({
                class_name: "start-widget",
                hpack: "start",
                children: [Workspace],
            }),
            endWidget: Widget.Box({
                class_name: "end-widget",
                hpack: "end",
                spacing: 12,
                children: [Battery, Date],
            }),
        }),
    });

App.config({
    // onConfigParsed: () => {
    //     battery();
    // },
    style: "./style/style.css",
    windows: [Bar(0)],
});