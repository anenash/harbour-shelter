import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Dialog {
    id: root

    canAccept: false

    property variant result: ({})

    function getInfo(data) {
        if (data !== "error") {
            var parsed = JSON.parse(data)
            if (parsed.status === "ok") {
                for (var i in parsed.results.locations) {
                    locationsModel.append(parsed.results.locations[i])
                }
                indicator.running = false
            }
        }
    }

    Component {
        id: highlight
        Rectangle {
            width: root.width
            height: Theme.itemSizeLarge
            color: "#c2dee4"
            y: locationsListView.currentItem.y;
            Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
        }
    }

    Database {
        id: database
    }

    ListModel {
        id: locationsModel
    }

    BusyIndicator {
        id: indicator

        anchors.centerIn: parent
        size: BusyIndicatorSize.Large
    }

    Column {
        width: parent.width

        DialogHeader {
            title: qsTr("Locations")
        }

        SearchField {
            id: searchField

            width: parent.width
            placeholderText: qsTr('Search locations:')

            onActiveFocusChanged: {
                if (focus) {
                    root.canAccept = false
                }
            }

            EnterKey.onClicked: {
                if(searchField.text.length > 1) {
                    indicator.running = true
                    focus = false
                    locationsListView.currentIndex = -1
                    locationsModel.clear()
                    var searchText = searchField.text.replace(/ /g, '%20')
                    //"query=prague&lang=en&lookFor=both&limit=10"
                    var url = Utils.locations + "lang=en&lookFor=city&limit=10&query=" + searchText
                    Utils.performRequest("GET", url, getInfo)
                }
            }
        }

        SilicaListView {
            id: locationsListView

            width: parent.width
            height: root.height * 0.7
            clip: true
            spacing: Theme.paddingSmall

            highlight: highlight
            highlightFollowsCurrentItem: false
            currentIndex: -1

            model: locationsModel
            delegate: ListItem {
                contentHeight: Theme.itemSizeLarge
                IconButton {
                    id: _locationType
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingLarge
                    z: 3
                    icon.source: "image://theme/icon-m-whereami"
                }
                Label {
                    id: locationFullName

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -Theme.paddingMedium
                    anchors.left: _locationType.right
                    anchors.leftMargin: Theme.paddingMedium
                    text: fullName
                }
                Text {
                    anchors.top: locationFullName.bottom
                    anchors.topMargin: Theme.paddingSmall
                    anchors.left: _locationType.right
                    anchors.leftMargin: Theme.paddingMedium
                    color: Theme.secondaryColor
                    text: "hotels count: " + hotelsCount
                }
                Separator {

                }

                onClicked: {
                    locationsListView.currentIndex = index
                    result.location = location
                    result.fullName = fullName
                    result.id = id
                    root.canAccept = true
                }
            }
        }
    }


    onAccepted: {
            return result
    }
}
