import QtQuick 2.9
import QtQml 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: window
    visible: true
    visibility: "Maximized"
    title: "hydron-qt"
    minimumWidth: 640
    minimumHeight: 480

    Item {
        id: overlay
        anchors.fill: parent
        z: 100

        FileView {
            id: fileView
            anchors.fill: parent
        }
    }

    header: ToolBar {
        ColumnLayout {
            anchors.fill: parent
            SearchBar {
                id: searchBar
                Layout.fillWidth: true
            }
            ProgressBar {
                visible: false
                Layout.fillWidth: true

                Component.onCompleted: {
                    go.set_progress_bar.connect(set)
                }

                function set(pos) {
                    visible = pos !== 0
                    value = pos
                }
            }
        }
    }

    ScrollView {
        id: browserContainer
        anchors.fill: parent

        Browser {
            id: browser
            anchors.fill: parent
        }
    }

    Shortcut {
        sequence: StandardKey.Quit
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }

    // Remove a file from the database nad update UI accordingly
    function removeFiles(ids) {
        for (var i = 0; i < ids.length; i++) {
            go.remove(ids[i])
        }
        fileView.remove()
        browser.loadThumbnails(searchBar.text)
    }

    ImportDialog {
        id: importDialog
    }

    DropArea {
        anchors.fill: parent
        keys: ["text/uri-list"]
        onDropped: {
            // Ignore internal drags
            if (drop.source || !drop.hasUrls) {
                return
            }
            drop.accepted = true
            importDialog.addFiles(drop.urls)
            importDialog.open()
        }
    }

    ErrorPopup {}
}
