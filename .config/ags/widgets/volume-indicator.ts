/// Ref: https://github.com/Aylur/ags-docs/blob/e9722d5dd9c3720f5b38569a95ad0f5aa2619332/src/content/docs/services/audio.md
import { VOLUME_INDICATOR_THRESHOLDS, WHITESUR_ICON_SIZE } from "constants";
const { speaker } = await Service.import("audio");

export default Widget.Button({
    class_name: "volume-indicator status-widget",
    on_clicked: () => (speaker.is_muted = !speaker.is_muted),
    setup: (self) =>
        self.hook(speaker, (self) => {
            let icon: string | undefined, tooltip_text: string;

            // The volume is not 0 when speaker is muted.
            if (speaker.is_muted) {
                tooltip_text = "Muted";
                icon = "muted";
            } else {
                const vol = speaker.volume * 100;
                icon = VOLUME_INDICATOR_THRESHOLDS.find(
                    ([_, value]) => value <= vol,
                )?.[0];
                tooltip_text = `Volume ${Math.floor(vol)}%`;
            }

            self.image = Widget.Icon({
                size: WHITESUR_ICON_SIZE.VOLUME_INDICATOR,
                icon: icon
                    ? `audio-volume-${icon}-symbolic`
                    : "audio-card-symbolic",
            });
            self.tooltip_text = tooltip_text;
        }),
});
