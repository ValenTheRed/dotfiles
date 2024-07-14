import { LOW_BATTERY_THRESHOLD } from "constants";
import { closeNotification } from "utils";

export default async () => {
    const daemon = await Service.import("battery");
    let hasNotified = false;
    let isChargingAfterNotify = false;
    let id: Awaited<ReturnType<typeof Utils.notify>>;
    daemon.connect("notify::charging", ({ charging }) => {
        if (charging && hasNotified) {
            isChargingAfterNotify = true;
            closeNotification(id);
        }
        if (!charging && hasNotified && isChargingAfterNotify) {
            hasNotified = false;
            isChargingAfterNotify = false;
        }
    });
    daemon.connect(
        "notify::percent",
        async ({ percent, charging, icon_name }) => {
            if (charging || percent > LOW_BATTERY_THRESHOLD || hasNotified) {
                return;
            }
            id = await Utils.notify({
                summary: "Low Battery",
                body: `Approximately ${percent}% remaining.`,
                urgency: "critical",
                iconName: icon_name,
                transient: true,
            });
            hasNotified = true;
        },
    );
};
