/// Reference: https://github.com/Aylur/ags/pull/246
import { WHITESUR_ICON_SIZE } from "constants";
import Sway from "services/sway";

export default Widget.Box({
    class_name: "workspace",
    children: Sway.bind("workspaces").as((workspaces) => {
        const btns = workspaces
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
            .filter((btn) => btn !== undefined)
            // NOTE: This don't work so well if we have actual strings in the
            // workspaces.
            .toSorted((b1, b2) => Number(b1.label) - Number(b2.label));

        let nextPredicted = btns[0].label === "1" ? 2 : 1;
        let addWorkspaceNumber = nextPredicted;
        for (const btn of btns) {
            if (Number(btn.label) + 1 === nextPredicted) {
                addWorkspaceNumber = nextPredicted++;
            } else {
                break;
            }
        }
        btns.push(
            Widget.Button({
                image: Widget.Icon({
                    size: WHITESUR_ICON_SIZE.DEFAULT,
                    // NOTE: "icon_name" prop doesn't work.
                    icon: "list-add-symbolic",
                }),
                class_name: "workspace-add",
                on_clicked: () =>
                    Sway.msg(`workspace number ${addWorkspaceNumber}`),
            }),
        );

        return btns;
    }),
});
