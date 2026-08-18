import QtQuick
import org.kde.plasma.configuration
import "../ui/Translator.js" as Tr

ConfigModel {
    ConfigCategory {
        name: Tr.t("Appearance")
        icon: "preferences-desktop-color"
        source: "configAppearance.qml"
    }
    ConfigCategory {
        name: Tr.t("Animation")
        icon: "preferences-desktop-effects"
        source: "configAnimation.qml"
    }
}
