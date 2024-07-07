import { WHITESUR_ICON_SIZE, AUDIO_APPLICATION } from "constants";
import Gtk from "types/@girs/gtk-3.0/gtk-3.0";
import { Stream } from "types/service/audio";

const audio = await Service.import("audio");
let previousApps = 0;

const Slider = (speaker: Stream) =>
    Widget.Box({
        children: [
            Widget.Icon({
                size: WHITESUR_ICON_SIZE.DEFAULT,
            }).hook(speaker, (self) => {
                self.tooltip_text =
                    speaker.name ?? AUDIO_APPLICATION.NAME.UNKOWN;

                let icon_name: Stream["icon_name"];
                const name = speaker.name?.toLowerCase();
                if (name?.includes("firefox")) {
                    icon_name = "firefox-symbolic";
                } else if (name?.includes("vlc")) {
                    icon_name = "vlc";
                } else if (name?.includes("chromium")) {
                    icon_name = "google-chrome-symbolic";
                } else {
                    icon_name = speaker.icon_name;
                }
                if (
                    icon_name &&
                    icon_name !==
                        AUDIO_APPLICATION.NAME.BUILT_IN_AUDIO_ANALOG_STEREO &&
                    Utils.lookUpIcon(icon_name, WHITESUR_ICON_SIZE.DEFAULT)
                ) {
                    self.icon_name = icon_name;
                } else {
                    self.icon_name = AUDIO_APPLICATION.ICON.SYSTEM;
                }
            }),
            Widget.Slider({
                class_name: "volume-slider",
                value: speaker.bind("volume").as((v) => v * 100),
                min: 0,
                max: 100,
                value_pos: Gtk.PositionType.RIGHT,
                on_change: (self) => {
                    speaker.volume = self.value / 100;
                },
            }),
        ],
    });

export default (monitor: number = 0) =>
    Widget.Window({
        setup: (self) =>
            self.keybind("Escape", () => App.closeWindow("volume-controls")),
        visible: false,
        keymode: "on-demand",
        layer: "top",
        class_name: "volume-controls",
        decorated: true,
        monitor,
        name: "volume-controls",
        exclusivity: "exclusive",
        anchor: ["right", "top"],
        child: Widget.Box({
            class_name: "volume-controls",
            vertical: true,
            children: [Slider(audio.speaker)],
            setup: (self) =>
                // NOTE: `ags` v1.8.2 doesn't support `audio.apps` as a valid
                // `Connectable`. Hence, a hook on `audio` and the global
                // `previousApps`.
                // TODO: make audio.apps a `Connectable`.
                self.hook(audio, (self) => {
                    if (
                        audio.apps.length <= 0 ||
                        audio.apps.length === previousApps
                    ) {
                        return;
                    }
                    const appSliders = audio.apps.map(Slider);
                    self.children = [Slider(audio.speaker), ...appSliders];
                    previousApps = appSliders.length;
                }),
        }),
    });
