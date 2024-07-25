/// Reference: https://github.com/Aylur/ags/pull/246
import Sway from "services/sway";

export default Widget.Box({
    class_name: "workspace",
    children: Sway.bind("workspaces").as((workspaces) =>
        workspaces
            .map((ws) => {
                const label = ws.name;
                if (label === "__i3_scratch") {
                    return undefined;
                }
                return Widget.Button({
                    label,
                    class_names: [
                        ws?.nodes.length + ws?.floating_nodes.length > 0
                            ? "workspace-occupied"
                            : "",
                        Sway.active.workspace.name === label
                            ? "workspace-active"
                            : "",
                    ],
                    on_clicked: () => Sway.msg(`workspace ${label}`),
                });
            })
            .filter((btn) => btn !== undefined),
    ),
});
