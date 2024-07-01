/// Ref: https://github.com/Aylur/ags-docs/blob/e9722d5dd9c3720f5b38569a95ad0f5aa2619332/src/content/docs/services/audio.md
import { VOLUME_INDICATOR_THRESHOLDS, WHITESUR_ICON_SIZE } from "constants";
const audio = await Service.import("audio");

export default Widget.Button({
    class_name: "volume-indicator status-widget",
    on_clicked: () => (audio.speaker.is_muted = !audio.speaker.is_muted),
    image: Widget.Icon({ size: WHITESUR_ICON_SIZE.VOLUME_INDICATOR }).hook(
        audio.speaker,
        (self) => {
            let icon: string | undefined, tooltip_text: string;
            // The volume is not 0 when speaker is muted.
            if (audio.speaker.is_muted) {
                tooltip_text = "Muted";
                icon = "muted";
            } else {
                const vol = audio.speaker.volume * 100;
                icon = VOLUME_INDICATOR_THRESHOLDS.find(
                    ([_, value]) => value <= vol,
                )?.[0];
                tooltip_text = `Volume ${Math.floor(vol)}%`;
            }
            self.icon = icon
                ? `audio-volume-${icon}-symbolic`
                : "audio-speakers-symbolic";
            self.tooltip_text = tooltip_text;
        },
    ),
});
