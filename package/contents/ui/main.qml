import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.plasma.private.mpris as Mpris
import "Translator.js" as Tr

PlasmoidItem {
    id: root

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    // Native hover tooltip showing current track/artist info
    toolTipMainText: mediaTitle || Tr.t("Music")
    toolTipSubText: mediaArtist || mediaIdentity || ""

    readonly property int compactMinWidth: 82
    readonly property int compactMaxWidth: 560
    readonly property int compactSidePadding: 18
    readonly property int compactTextMaxWidth: 420
    readonly property int compactTextWidth: Math.min(compactTextMaxWidth, Math.ceil(compactTitleMetrics.width))
    readonly property int compactLeadingWidth: 24
    readonly property int compactTrailingWidth: 30
    readonly property int compactGapWidth: 16
    readonly property int compactContentWidth: compactLeadingWidth + compactTextWidth + compactTrailingWidth + compactGapWidth
    readonly property int compactWidth: Math.max(compactMinWidth, Math.min(compactMaxWidth, compactContentWidth + compactSidePadding * 2))
    readonly property int compactHeight: 32

    readonly property bool animationsEnabled: Plasmoid.configuration.animationsEnabled
    readonly property real animMultiplier: 100 / Math.max(40, Plasmoid.configuration.animationSpeed)
    readonly property string accent: Plasmoid.configuration.accentColor
    readonly property bool followTheme: Plasmoid.configuration.followSystemTheme

    // Text colors
    readonly property color textPrimary: followTheme ? Kirigami.Theme.textColor : "white"
    readonly property color textSecondary: followTheme
        ? withAlpha(Kirigami.Theme.textColor, 75)
        : Qt.rgba(1, 1, 1, 0.74)

    readonly property int mediaCount: mediaRepeater.count
    readonly property bool hasMedia: mediaCount > 0
    readonly property bool mediaPlaying: mediaStatus === Mpris.PlaybackStatus.Playing
    readonly property string compactTitle: mediaTitle || Tr.t("Music")

    property int mediaStatus: Mpris.PlaybackStatus.Stopped
    property real mediaPosition: 0
    property real mediaLength: 0
    readonly property real mediaProgress: mediaLength > 0 ? Math.max(0, Math.min(1, mediaPosition / mediaLength)) : 0
    property string mediaTitle: ""
    property string mediaArtist: ""
    property string mediaArtUrl: ""
    property string mediaIdentity: ""
    property var mediaContainer: null

    Layout.minimumWidth: compactWidth
    Layout.minimumHeight: compactHeight
    Layout.preferredWidth: compactWidth
    Layout.preferredHeight: compactHeight
    Layout.maximumWidth: compactWidth
    Layout.maximumHeight: compactHeight

    implicitWidth: Layout.preferredWidth
    implicitHeight: Layout.preferredHeight

    TextMetrics {
        id: compactTitleMetrics
        text: root.compactTitle
        font.pointSize: 12
        font.weight: Font.Medium
    }

    function dur(ms) {
        return animationsEnabled ? Math.round(ms * animMultiplier) : 0
    }

    function withAlpha(hex, percent) {
        const c = Qt.lighter(hex, 1.0)
        return Qt.rgba(c.r, c.g, c.b, Math.max(0, Math.min(100, percent)) / 100)
    }

    function setMedia(roleModel) {
        mediaTitle = roleModel.track || ""
        mediaArtist = roleModel.artist || roleModel.identity || ""
        mediaArtUrl = roleModel.artUrl || ""
        mediaIdentity = roleModel.identity || ""
        mediaStatus = roleModel.playbackStatus
        mediaPosition = roleModel.position || 0
        mediaLength = roleModel.length || 0
        mediaContainer = roleModel.container
    }

    // Scroll over the capsule controls the active media player: volume when the
    // player exposes it, otherwise skip to the next/previous track.
    function handleWheel(deltaY) {
        if (!mediaContainer || deltaY === 0) {
            return
        }
        const up = deltaY > 0
        if (typeof mediaContainer.volume === "number") {
            const step = 0.05
            mediaContainer.volume = Math.max(0, Math.min(1, mediaContainer.volume + (up ? step : -step)))
        } else if (up) {
            mediaContainer.Next()
        } else {
            mediaContainer.Previous()
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            if (root.mediaContainer && root.mediaPlaying) {
                root.mediaContainer.updatePosition()
            }
        }
    }

    Repeater {
        id: mediaRepeater

        model: Mpris.MultiplexerModel {
        }

        Item {
            readonly property string trackValue: model.track || ""
            readonly property string artistValue: model.artist || ""
            readonly property string artValue: model.artUrl || ""
            readonly property int statusValue: model.playbackStatus
            readonly property real positionValue: model.position || 0
            readonly property real lengthValue: model.length || 0

            visible: false
            Component.onCompleted: {
                if (index === 0) {
                    root.setMedia(model)
                }
            }
            onTrackValueChanged: if (index === 0) root.setMedia(model)
            onArtistValueChanged: if (index === 0) root.setMedia(model)
            onArtValueChanged: if (index === 0) root.setMedia(model)
            onPositionValueChanged: if (index === 0) root.setMedia(model)
            onLengthValueChanged: if (index === 0) root.setMedia(model)
            onStatusValueChanged: {
                if (index === 0) {
                    root.setMedia(model)
                }
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        onWheel: (wheel) => root.handleWheel(wheel.angleDelta.y)
    }

    Rectangle {
        id: island

        anchors.centerIn: parent
        width: root.compactWidth
        height: root.compactHeight
        radius: height / 2
        color: "transparent"
        border.width: 0
        transformOrigin: Item.Center

        Behavior on width { NumberAnimation { duration: root.animationsEnabled ? Math.round(220 * root.animMultiplier) : 0; easing.type: Easing.OutCubic } }

        RowLayout {
            id: compactLayout

            anchors.fill: parent
            anchors.leftMargin: root.compactSidePadding
            anchors.rightMargin: root.compactSidePadding
            spacing: 8

            MediaCompactIcon {
                artUrl: root.mediaArtUrl
                Layout.preferredWidth: 22
                Layout.preferredHeight: 22
            }

            PlasmaComponents.Label {
                text: root.compactTitle
                color: root.textPrimary
                font.pointSize: 12
                font.weight: Font.Medium
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.maximumWidth: root.compactTextMaxWidth
            }

            SoundBars {
                playing: root.mediaPlaying
                Layout.preferredWidth: 30
                Layout.preferredHeight: 26
            }
        }
    }

    component MediaCompactIcon: Item {
        property string artUrl: ""

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: Qt.rgba(1, 1, 1, 0.12)
            visible: artUrl.length === 0

            Kirigami.Icon {
                anchors.centerIn: parent
                width: parent.width * 0.7
                height: width
                source: "audio-x-generic"
            }
        }

        Image {
            anchors.fill: parent
            visible: artUrl.length > 0
            source: artUrl
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }
    }

    component SoundBars: Row {
        property bool playing: false

        spacing: 5
        width: 44
        height: 34

        Repeater {
            model: [18, 27, 14, 24, 20]

            Rectangle {
                id: bar

                width: 4
                height: modelData
                y: (parent.height - height) / 2
                radius: 2
                color: root.textPrimary
                opacity: playing ? 0.9 : 0.55
                transformOrigin: Item.Center
                transform: Scale {
                    id: barScale
                    origin.x: bar.width / 2
                    origin.y: bar.height / 2
                    xScale: 1
                    yScale: playing ? 1 : 0.45

                    SequentialAnimation on yScale {
                        running: playing
                        loops: Animation.Infinite
                        NumberAnimation {
                            to: 0.35 + ((index * 17) % 45) / 100
                            duration: 260 + index * 45
                            easing.type: Easing.InOutSine
                        }
                        NumberAnimation {
                            to: 1
                            duration: 260 + index * 45
                            easing.type: Easing.InOutSine
                        }
                    }
                }
            }
        }
    }
}
