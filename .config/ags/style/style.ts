const styleDir = `${App.configDir}/style`;

Utils.monitorFile(
    styleDir,

    function () {
        const css = `${styleDir}/style.css`;
        App.resetCss();
        App.applyCss(css);
    },
);
