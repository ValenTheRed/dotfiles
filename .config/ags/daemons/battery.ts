import { LOW_BATTERY_THRESHOLD } from "constants";

export default async () => {
    const daemon = await Service.import("battery");
    let hasNotified = false;
    let isChargingAfterNotify = false;
    daemon.connect("notify::charging", ({ charging }) => {
        if (charging && hasNotified) {
            isChargingAfterNotify = true;
        }
        if (!charging && hasNotified && isChargingAfterNotify) {
            hasNotified = false;
            isChargingAfterNotify = false;
        }
    });
    daemon.connect("notify::percent", ({ percent, charging, icon_name }) => {
        if (charging || percent > LOW_BATTERY_THRESHOLD || hasNotified) {
            return;
        }
        Utils.notify({
            summary: "Low Battery",
            body: `Approximately ${percent}% remaining.`,
            urgency: "critical",
            iconName: icon_name,
        });
        hasNotified = true;
    });
};
