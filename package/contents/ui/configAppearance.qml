import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import "Translator.js" as Tr

Kirigami.FormLayout {
    id: page

    property alias cfg_followSystemTheme: themeSwitch.checked
    property string cfg_accentColor: "#8d5cff"

    QQC2.Switch {
        id: themeSwitch
        Kirigami.FormData.label: Tr.t("Plasma theme:")
        text: Tr.t("Use the desktop theme's text color")
    }

    QQC2.Label {
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        opacity: 0.7
        font: Kirigami.Theme.smallFont
        text: Tr.t("When on, text follows your desktop theme's text color.")
    }

    Item { Kirigami.FormData.isSection: true }

    RowLayout {
        Kirigami.FormData.label: Tr.t("Accent color:")
        Repeater {
            model: ["#8d5cff", "#2da6e8", "#55e36a", "#ff4f6f", "#ffaa33", "#ffffff"]
            ColorSwatch { swatch: modelData; selected: page.cfg_accentColor === modelData; onPicked: page.cfg_accentColor = modelData }
        }
    }

    QQC2.TextField {
        Kirigami.FormData.label: Tr.t("Custom accent (hex):")
        text: page.cfg_accentColor
        inputMask: "\\#HHHHHH"
        onEditingFinished: if (text.length === 7) page.cfg_accentColor = text
    }

    component ColorSwatch: Rectangle {
        property string swatch: "#ffffff"
        property bool selected: false
        signal picked()

        width: Kirigami.Units.gridUnit * 1.6
        height: width
        radius: width / 2
        color: swatch
        border.width: selected ? 3 : 1
        border.color: selected ? Kirigami.Theme.highlightColor : Qt.rgba(1, 1, 1, 0.25)

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.picked()
        }
    }
}
