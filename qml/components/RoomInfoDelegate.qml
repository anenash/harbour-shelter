import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "Utils.js" as Utils

ListItem {
    property variant roomData: ({})

    Database {
        id: database
    }

    contentHeight: Theme.itemSizeHuge
    width: parent.width

    Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin
        anchors.right: priceItem.left
        anchors.rightMargin: Theme.paddingMedium
        color: Theme.secondaryHighlightColor
        wrapMode: Text.WordWrap
        text: desc
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingMedium
        anchors.left: parent.left
        anchors.leftMargin: Theme.horizontalPageMargin
        color: Theme.secondaryHighlightColor
        font.pixelSize: Theme.fontSizeTiny
        text: qsTr("Agency: ") + agencyName
    }


    Text {
        id: priceItem

        anchors.bottom: reserveButton.top
        anchors.bottomMargin: Theme.paddingSmall
        anchors.right: parent.right
        anchors.rightMargin: Theme.horizontalPageMargin
        width: parent.width * 0.3
        color: Theme.primaryColor
        horizontalAlignment: Text.AlignLeft
        text: qsTr("Total: ") + total + " " + database.currency + "\n" + qsTr("per nigth: ") + price + " " + database.currency
    }

    Button {
        id: reserveButton

        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.paddingMedium
        anchors.right: parent.right
        anchors.rightMargin: Theme.horizontalPageMargin
        text: qsTr("Reserve a room")
        onClicked: {
            if (database.getValue("links") == 0) {
                pageStack.push(Qt.resolvedUrl("../pages/WebPage.qml"), {"pageUrl": fullBookingURL})
            } else {
                Qt.openUrlExternally(fullBookingURL)
            }
        }
    }

    Separator {
        width: parent.width
    }

    onClicked: {
        if (database.getValue("links") == 0) {
            pageStack.push(Qt.resolvedUrl("../pages/WebPage.qml"), {"pageUrl": fullBookingURL})
        } else {
            Qt.openUrlExternally(fullBookingURL)
        }
    }
}
