export const closeNotification = (id: number) => {
    const dest = "org.freedesktop.Notifications";
    const objectPath = "/org/freedesktop/Notifications";
    const method = "org.freedesktop.Notifications.CloseNotification";
    Utils.execAsync(
        `gdbus call --session --dest ${dest} --object-path ${objectPath} --method ${method} "${id}"`,
    );
};
