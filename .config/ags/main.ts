import "style";
import battery from "daemons/battery";
import { VolumeControls, StatusBar } from "windows";

App.config({
    onConfigParsed: () => {
        battery();
    },
    /// Ref: https://github.com/vinceliuice/WhiteSur-icon-theme
    iconTheme: "WhiteSur",
    style: "./style/style.css",
    windows: [StatusBar(0), VolumeControls(0)],
});
