import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Page {
    Column {
        anchors.fill: parent
        PageHeader {
            id: header

            title: "About"
        }
        Column {
            id: content

            anchors.top: header.bottom
            width: parent.width
            spacing: Theme.paddingMedium
            Label {
                width: parent.width
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                text: '<p>Travelpayouts is a pay-per-action travel affiliate program of JetRadar/Aviasales/Hotellook travel search, including such brands as&nbsp;<a href="http://www.jetradar.com/">Jetradar.com</a>, &nbsp;<a href="http://hotellook.com/">Hotellook.com</a>, &nbsp;and <a href="http://www.aviasales.ru/">Aviasales.ru</a></p>'
                onLinkActivated: {
                    Qt.openUrlExternally(link)
                }
            }
            Separator {
                width: parent.width
            }
            TextArea {
                anchors.margins: Theme.horizontalPageMargin
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "All donations will go for the purchase of the Sailfish device."
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Donate"
                onClicked: {
                    Qt.openUrlExternally("https://www.paypal.me/anenash")
                }
            }
        }
    }
}
