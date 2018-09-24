import QtQuick 2.6
import QtPositioning 5.3
import QtLocation 5.0
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Page {
    property variant hotelData: ({})
    property variant hotelRooms: ([])

    QtObject {
        id: internal

        property variant hotelPhotos: []
    }

    ListModel {
        id: rooms
    }

    Database {
        id: database
    }

    Plugin {
        id: mapPlugin

        name: "osm"
        preferred:"osm"
        locales: ["fr_FR","en_US","de_DE","ru_RU"]
    }

    Component.onCompleted: {
        database.storeFavorite(hotelData.id, JSON.stringify(hotelData))

        var r = JSON.parse(hotelRooms)
        for (var i in r) {
            rooms.append(r[i])
        }

        var url = "https://yasen.hotellook.com/photos/hotel_photos?id=" + hotelData.id
        Utils.performRequest("GET", url, getImages)
    }

    function getImages(data) {
        if (data !== "error") {
            var parsed = JSON.parse(data)
            for (var i in parsed[hotelData.id]) {
                internal.hotelPhotos.push(parsed[hotelData.id][i])
            }
        }
        hotelsSlide.model = internal.hotelPhotos.length
        console.log(internal.hotelPhotos)
    }

    PageHeader {
        id: pageHeader

        title: hotelData.name
    }

    ListView {
        id: hotelsSlide

        anchors.top: pageHeader.bottom
        anchors.topMargin: Theme.paddingMedium
        width: parent.width
        height: 300 * Theme.pixelRatio

        orientation: ListView.Horizontal
        spacing: Theme.paddingSmall
        clip: true
        model: 0
        delegate: Image {
            height: 300 * Theme.pixelRatio

            fillMode: Image.PreserveAspectFit
            source: "https://photo.hotellook.com/image_v2/limit/" + internal.hotelPhotos[index] + "/800/520.auto"

            BusyIndicator {
                anchors.centerIn: parent
                running: parent.status === Image.Loading
            }
        }
        header: Map {
            id: hotelLocation

            height: 300 * Theme.pixelRatio
            width: 400 * Theme.pixelRatio
            gesture.enabled: false
            plugin: mapPlugin
            center: QtPositioning.coordinate(hotelData.location.lat, hotelData.location.lon)
            zoomLevel: 14.0

            MapQuickItem {
                id: hotelPointer

                anchorPoint.x: locationPointer.width / 2
                anchorPoint.y: locationPointer.height

                coordinate: parent.center
                sourceItem: IconButton {
                    id: locationPointer

                    z: 3
                    icon.source: "image://theme/icon-m-whereami"
                }

            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("MapPage.qml"), {latitude: hotelData.location.lat, longitude: hotelData.location.lon})
                }

            }

            Component.onCompleted: {
                zoomLevel = 16.0
            }
        }
    }

    DetailItem {
        id: detailAddress

        anchors.top: hotelsSlide.bottom
        anchors.topMargin: Theme.paddingMedium
        width: parent.width
        leftMargin: Theme.paddingSmall
        label: "Address:"
        value: hotelData.address

        MouseArea {
            anchors.fill: parent

            onClicked: {
                pageStack.push(Qt.resolvedUrl("MapPage.qml"), {latitude: hotelData.location.lat, longitude: hotelData.location.lon})
            }
        }
    }

    ListView {
        anchors.top: detailAddress.bottom
        anchors.topMargin: Theme.paddingMedium
        anchors.bottom: parent.bottom
        width: parent.width
        clip: true

        model: rooms

        delegate: ListItem {
            contentHeight: Theme.itemSizeLarge
            width: parent.width

            Text {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                width: parent.width
                color: Theme.secondaryHighlightColor
                text: "Agency: " + agencyName
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                width: parent.width
                color: Theme.secondaryHighlightColor
                wrapMode: Text.WordWrap
                text: desc
            }
            Text {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                width: parent.width
                color: Theme.secondaryHighlightColor
                text: "Price: " + total + " " + database.currency + " (one nigth: " + price + " " + database.currency + ")"
            }

            Separator {
                width: parent.width
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl("WebPage.qml"), {"pageUrl": fullBookingURL})
            }
        }
    }

    ViewPlaceholder {
        enabled: rooms.count == 0
        text: "Hotels did not found"
        hintText: "Please, change check-in date"
    }
}
