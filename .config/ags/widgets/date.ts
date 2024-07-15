const date = Variable("", {
    poll: [1000, "date '+%a, %e %b %l:%M %P'"],
});

export default Widget.Button({
    class_name: "date status-widget",
    label: date.bind(),
    on_primary_click: () => App.toggleWindow("calendar"),
});
