const Calendar = Widget.Calendar({
    class_name: "calendar",
    show_day_names: true,
    show_details: true,
    show_heading: true,
    show_week_numbers: true,
});

export default (monitor: number = 0) =>
    Widget.Window({
        setup: (self) =>
            self.keybind("Escape", () => App.closeWindow("calendar")),
        visible: false,
        keymode: "exclusive",
        margins: [3, 3, 0, 0],
        layer: "top",
        class_name: "calendar",
        monitor,
        name: "calendar",
        exclusivity: "exclusive",
        anchor: ["right", "top"],
        child: Calendar,
    });
