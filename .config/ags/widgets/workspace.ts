import Sway from "services/sway";

const WorkspaceBox = Widget.Box({
    class_name: "workspace-box",
    children: Array.from({ length: 9 }, (_, i) => {
        i += 1;
        return Widget.Button({
            setup: (btn) => {
                btn.hook(
                    Sway,
                    (btn) => {
                        const ws = Sway.getWorkspace(String(i));
                        btn.visible = ws !== undefined;
                        btn.toggleClassName(
                            "workspace-occupied",
                            ws?.nodes.length + ws?.floating_nodes.length > 0,
                        );
                    },
                    "notify::workspaces",
                );

                btn.hook(Sway.active.workspace, (btn) => {
                    btn.toggleClassName(
                        "workspace-active",
                        Sway.active.workspace.name === String(i),
                    );
                });
            },
            label: String(i),
            on_clicked: () => Sway.msg(`workspace ${i}`),
            // child: Widget.Label({
            //     label: String(i),
            //     class_name: "workspace-indicator",
            //     vpack: "center",
            // }),
        });
    }),
});

export default Widget.EventBox({
    // class_name: "workspaces panel-button",
    // child: Widget.Box({
    //     child: Widget.EventBox({
    on_scroll_up: () => Sway.msg("workspace next"),
    on_scroll_down: () => Sway.msg("workspace prev"),
    class_name: "workspace",
    child: WorkspaceBox,
    // }),
    // }),
});
