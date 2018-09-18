import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Page {
    id: root

    ListModel {
        id: favoritesModel
    }

    SilicaFlickable {
        anchors.fill: parent

        PageHeader {
            id: head
            title: qsTr("Hotel booking")
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                }
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
                }
            }
            MenuItem {
                text: qsTr("Search")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SearchPage.qml"))
                }
            }
        }

        //    *** FAVORITES ***
        SilicaListView {
            id: favoritesListView

            anchors { top: head.bottom; left: parent.left; right: parent.right; bottom: parent.bottom}

            spacing: Theme.paddingSmall
            clip: true
            //                visible: !busyIndicator.running
            header: SectionHeader {
                text: qsTr("Search history")
            }

            model: favoritesModel
            delegate: Rectangle {

            }
            footer: ListItem {
                contentHeight: Theme.itemSizeMedium
                Label {
                    anchors.centerIn: parent
                    text: qsTr("New search")
                }
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SearchPage.qml"))
                }
            }

        }
    }
}
