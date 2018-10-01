import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
        id: appIcon
        source: "harbour-shelter.png"
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        width: Theme.iconSizeLauncher
    }

    Label {
        id: label
        anchors.top: appIcon.bottom
        anchors.topMargin: Theme.paddingMedium
        anchors.horizontalCenter: appIcon.horizontalCenter
        text: qsTr("Shelter")
    }

//    CoverActionList {
//        id: coverAction

//        CoverAction {
//            iconSource: "image://theme/icon-cover-search"
//        }
//    }
}
