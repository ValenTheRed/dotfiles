export const LOW_BATTERY_THRESHOLD = 20;
export const LABEL_ICON_SPACING = 3;
export const WHITESUR_ICON_SIZE = {
    VOLUME_INDICATOR: 22,
    DEFAULT: 20,
};
export const WIDGET_SPACING = 0;
export const VOLUME_INDICATOR_THRESHOLDS = [
    ["overamplified", 101],
    ["high", 67],
    ["medium", 34],
    ["low", 1],
    ["muted", 0],
] as const;
export const SYMBOLIC_ICON_POSTFIX = "-symbolic";
export const AUDIO_APPLICATION = {
    ICON: {
        SYSTEM: "computer-symbolic",
    },
    NAME: {
        BUILT_IN_AUDIO_ANALOG_STEREO:
            "alsa_output.pci-0000_00_1b.0.analog-stereo",
        UNKOWN: "Unknown",
    },
} as const;
