import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "Utils.js" as Utils

ListItem {
    property variant hotelData: ({})
    property variant hotelRooms: ([])

    contentHeight: Theme.itemSizeLarge
    width: parent.width

    Database {
        id: database
    }

    Image {
        id: _hotelStars

        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.05
        fillMode: Image.PreserveAspectFit
        source: "../images/" + hotelData.stars + ".png"
    }

    Label {
        id: _hotelTitle

        anchors.left: _hotelStars.right
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.right: hotelPrice.left
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingMedium
        horizontalAlignment: Text.AlignLeft

        text: hotelData.name
    }

    Text {
        id: hotelRate
        anchors.left: _hotelStars.right
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingMedium
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeTiny

        text: qsTr("Rating: ") + hotelData.rating
    }

    Text {
        id: hotelFromCenter
        anchors.right: hotelPrice.left
        anchors.rightMargin: Theme.horizontalPageMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingMedium
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeTiny

        text: qsTr("from center: ") + hotelData.distance + " km"
    }

    Text {
        id: hotelPrice

        anchors.right: parent.right
        anchors.rightMargin: Theme.horizontalPageMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingMedium
        width: parent.width * 0.15
        color: Theme.secondaryColor

        text: qsTr("Price from\n") + hotelData.price + " " + database.currency
    }

    onClicked: {
        pageStack.push(Qt.resolvedUrl("../pages/HotelInfoPage.qml"), {"hotelData": hotelData, "hotelRooms": hotelRooms})
    }
}
