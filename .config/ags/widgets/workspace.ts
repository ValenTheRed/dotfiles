/// Reference: https://github.com/Aylur/ags/pull/246
import Sway from "services/sway";

export default Widget.Box({
    class_name: "workspace",
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
        });
    }),
});
