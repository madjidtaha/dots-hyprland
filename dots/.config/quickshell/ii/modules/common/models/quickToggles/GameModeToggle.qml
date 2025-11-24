import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    id: root
    name: Translation.tr("Game mode")
    toggled: toggled
    icon: "gamepad"
    property int originalCornerStyle: 0 

    mainAction: () => {
        root.toggled = !root.toggled
        if (root.toggled) {
            Quickshell.execDetached(["bash", "-c", `hyprctl --batch "keyword animations:enabled 0; keyword decoration:shadow:enabled 0; keyword decoration:blur:xray 0; keyword decoration:blur:brightness 0; keyword decoration:blur:contrast 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 0; keyword decoration:rounding 0; keyword general:allow_tearing 1;"`])
            root.originalCornerStyle = Config.options.bar.cornerStyle
            Config.options.bar.cornerStyle = 2 
        } else {
            Quickshell.execDetached(["hyprctl", "reload"])
            Config.options.bar.cornerStyle = root.originalCornerStyle
        }
    }
    Process {
        id: fetchActiveState
        running: true
        command: ["bash", "-c", `test "$(hyprctl getoption animations:enabled -j | jq ".int")" -ne 0`]
        onExited: (exitCode, exitStatus) => {
            root.toggled = exitCode !== 0 // Inverted because enabled = nonzero exit
        }
    }
    tooltipText: Translation.tr("Game mode")
}
