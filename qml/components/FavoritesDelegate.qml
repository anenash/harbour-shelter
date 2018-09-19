import QtQuick 2.6
import Sailfish.Silica 1.0

import "Utils.js" as Utils

ListItem {
    id: root

    property string hotelTitle: ""
    property string hotelLocation: ""
    property string hotelStars: "0"
    property string fromCenter: ""
    property string hotelId: ""
    property string locationId: ""


    contentHeight: Theme.itemSizeHuge

    Text {
        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.right: stars.left
        anchors.top: parent.top

        font.pixelSize: Theme.fontSizeExtraSmall
        font.bold: true
        color: Theme.primaryColor

        text: hotelTitle
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.right: stars.left
        anchors.bottom: parent.bottom

        font.pixelSize: Theme.fontSizeExtraSmall
        font.bold: true
        color: Theme.primaryColor

        text: hotelLocation
    }

    Image {
        id: stars

        anchors.right: parent.right
        anchors.rightMargin: Theme.paddingMedium
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * 0.05
        fillMode: Image.PreserveAspectFit

        source: "../images/" + hotelStars + ".png"
    }

    onClicked: {
        console.log(hotelTitle)
    }
}
