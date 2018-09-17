import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

import "components/Utils.js" as Utils

ApplicationWindow
{
    id: app

    property string myIp: "127.0.0.1"

    function getMyIp(data) {
        if (data !== "error") {
            myIp = data
        }
    }

    Component.onCompleted: {
        Utils.performRequest("GET", Utils.getMyIpUrl, getMyIp)
    }

    initialPage: Component { StartPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.Portrait
}
