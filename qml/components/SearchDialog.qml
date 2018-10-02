import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Dialog {
    id: root

    canAccept: false

    property string requestType: "city"

    QtObject {
        id: internal

        property real lat: 59.91
        property real lon: 10.75
    }

    property variant result: ({})

    function getInfo(data) {
        if (data !== "error") {
            var parsed = JSON.parse(data)
            if (parsed.status === "ok") {
                if (requestType === "city") {
                    for (var i in parsed.results.locations) {
                        locationsModel.append(parsed.results.locations[i])
                    }
                } else {
                    for (var i in parsed.results.hotels) {
                        locationsModel.append(parsed.results.hotels[i])
                    }
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

    Component {
        id: searchFieldComponent

        SearchField {
            id: searchField

            width: parent.width
            placeholderText: requestType === "city" ?
                                 qsTr('Search locations:') :
                                 qsTr('Search hotels:')

            onActiveFocusChanged: {
                if (focus) {
                    root.canAccept = false
                }
            }

            EnterKey.onClicked: {
                if(searchField.text.length > 1) {
                    indicator.visible = true
                    indicator.running = true
                    focus = false
                    locationsListView.currentIndex = -1
                    locationsModel.clear()
                    var searchText = searchField.text.replace(/ /g, '%20')
                    var lang = database.language.substring(0,2)
                    //"query=prague&lang=en&lookFor=both&limit=10"
                    var url = Utils.locations + "lang=" + lang + "&lookFor=" + requestType + "&limit=40&query=" + searchText
                    Utils.performRequest("GET", url, getInfo)
                }
            }
        }
    }

    Component {
        id: coordinatesSearchComponent

        IconTextSwitch {
            automaticCheck: false
            text: qsTr('Search locations by coordinates')
            icon.source: "image://theme/icon-m-gps"
            onClicked: {
                var coord = pageStack.push(Qt.resolvedUrl("../pages/MapPage.qml"), {latitude: internal.lat, longitude: internal.lon, zoom: 7.0})
                coord.setLocation.connect(function() {
                    indicator.visible = true
                    indicator.running = true
                    internal.lat = coord.lat
                    internal.lon = coord.lon
                    locationsListView.currentIndex = -1
                    locationsModel.clear()
                    var lang = database.language.substring(0,2)
                    //"query=prague&lang=en&lookFor=both&limit=10"
                    var url = Utils.locations + "lang=" + lang + "&lookFor=hotel" + "&limit=20&query=" + internal.lat + "," + internal.lon
                    Utils.performRequest("GET", url, getInfo)
                })
            }
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
        visible: false
    }

    Component.onCompleted: {
        indicator.running = true
        console.log("requestType", requestType)
    }

    Column {
        width: parent.width

        Loader {
            width: parent.width
            sourceComponent: requestType === "coordinates"? coordinatesSearchComponent : searchFieldComponent
        }

        SilicaListView {
            id: locationsListView

            width: parent.width
            height: root.height

            clip: true
            spacing: Theme.paddingSmall

//            highlight: highlight
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
                Text {
                    id: locationFullName

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -Theme.paddingMedium
                    anchors.left: _locationType.right
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingMedium
                    text: requestType !== "coordinates" ? fullName : name
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.WordWrap
                }
                Text {
                    anchors.top: locationFullName.bottom
                    anchors.topMargin: Theme.paddingSmall
                    anchors.left: _locationType.right
                    anchors.leftMargin: Theme.paddingMedium
                    color: Theme.secondaryColor
                    text: requestType === "city" ? qsTr("hotels count: ") + hotelsCount : ""
                }
                Separator {

                }

                onClicked: {
                    locationsListView.currentIndex = index
                    result.location = location
                    result.fullName = requestType !== "coordinates" ? fullName : name
                    result.id = id
                    root.canAccept = true
                    root.accept()
                }
            }

            ViewPlaceholder {
                enabled: locationsModel.count == 0 && !indicator.visible
                text: qsTr("No hotels/locations found")
                hintText: requestType === "coordinates" ?
                              qsTr("Open a map by tapping on search field on top of the page. Tap and hold to select location on the map, than press the \"Set\" button."):
                              qsTr("Tap on search field on top of the page")
            }
        }
    }

    onAccepted: {
            return result
    }
}
