import QtQuick 2.6
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

    Component.onCompleted: {
//        console.log(JSON.stringify(hotelRooms))
//        console.log(JSON.stringify(hotelData))
//        console.log(JSON.stringify(hotelData.rooms))

//        console.log(JSON.stringify(hotelData.amenities))

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
    }

    DetailItem {
        id: detailAddress

        anchors.top: hotelsSlide.bottom
        anchors.topMargin: Theme.paddingMedium
        width: parent.width
        leftMargin: Theme.paddingSmall
        label: "Address:"
        value: hotelData.address
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
                text: "Price: " + total + " (one nigth: " + price + ")"
            }

            Separator {
                width: parent.width
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl("WebPage.qml"), {"pageUrl": fullBookingURL})
            }
        }
    }
}
