const date = Variable("", {
    poll: [1000, "date '+%a, %e %b %l:%M %P'"],
});

export default Widget.Label({
    class_name: "date status-widget",
    label: date.bind(),
});
