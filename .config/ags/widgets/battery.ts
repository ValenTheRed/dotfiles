const battery = await Service.import("battery");

const Icon = Widget.Icon({
    icon: battery.bind("icon_name"),
});
const Label = Widget.Label({
    label: battery.bind("percent").as((p) => String(p) + "%"),
});

export default Widget.Box({
    spacing: 5,
    children: [Label, Icon],
});
