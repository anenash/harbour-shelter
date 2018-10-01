import QtQuick 2.6
import QtPositioning 5.3
import QtLocation 5.0
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Page {
    id: root

    backNavigation: false

    property real latitude: 59.91
    property real longitude: 10.75
    property real lat: 59.91
    property real lon: 10.75

    property real zoom: 10.0

    signal setLocation(real lat, real lon)

    Component.onCompleted: {
        map.center = QtPositioning.coordinate(root.latitude, root.longitude)
        map.zoomLevel = root.zoom

        hotelPointer.coordinate = QtPositioning.coordinate(root.latitude, root.longitude)
        hotelStars.average  = 3.0
    }

    SearchDialog {
        id: searchDialog
    }

    Ratings {
        id: hotelStars
        maximum: 5.0
    }

    Location {
        id: hotelLocation
    }

    Plugin {
        id: plugin

        name: "osm"
        preferred:"osm"
        locales: ["fr_FR","en_US","de_DE","ru_RU"]
    }

    Map {
        id: map

        anchors.fill: parent
        plugin: plugin
        gesture.enabled: true

        MapQuickItem {
            id: hotelPointer

            anchorPoint.x: locationPointer.width / 2
            anchorPoint.y: locationPointer.height
            sourceItem: IconButton {
                id: locationPointer

                z: 3
                icon.source: "image://theme/icon-m-whereami"

                onClicked: {
                    console.log("hotel pointer", map.center, "stars", hotelStars.average)
                }
            }

        }

        MapQuickItem {
            id:marker

            sourceItem: IconButton {
                id: image
                icon.source: "../images/hotelPointer.png"

            }
            visible: false
            coordinate: map.center

            anchorPoint.x: image.width / 2
            anchorPoint.y: image.height / 2
        }

        MouseArea {
            anchors.fill: parent
            onPressAndHold: {
                hotelLocation.coordinate = map.toCoordinate(Qt.point(mouse.x,mouse.y))
                marker.coordinate = map.toCoordinate(Qt.point(mouse.x,mouse.y))
                marker.visible = true
            }
        }


        MapQuickItem {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: Theme.horizontalPageMargin
            anchors.bottomMargin: Theme.paddingMedium
            sourceItem: Button {
                text: qsTr("Reset")
                color: "black"
                opacity: 0.7

                onClicked: {
                    marker.visible = false
                    map.center = map.toCoordinate(Qt.point(mouse.x,mouse.y))
                    console.log(map.center, "before")
                    map.center = QtPositioning.coordinate(root.latitude, root.longitude)
                    marker.coordinate = QtPositioning.coordinate(root.latitude, root.longitude)
                    console.log(map.center, "after")
                }
            }
        }

        MapQuickItem {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: Theme.horizontalPageMargin
            anchors.bottomMargin: Theme.paddingMedium
            sourceItem: Button {
                text: marker.visible?qsTr("Set"):qsTr("Back")
                color: "black"
                opacity: 0.7

                onClicked: {
                    if (marker.visible) {
                        root.lat = hotelLocation.coordinate.latitude
                        root.lon = hotelLocation.coordinate.longitude
                        root.setLocation(hotelLocation.coordinate.latitude, hotelLocation.coordinate.longitude)
                    }
                    root.backNavigation = true
                    pageStack.pop()
                }
            }
        }
    }


    NumberAnimation {
        target: map
        property: "center"
        duration: 400
        easing.type: Easing.InOutQuad
    }
}
