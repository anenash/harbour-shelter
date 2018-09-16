import QtQuick 2.6
import Sailfish.Silica 1.0

import "../components/Utils.js" as Utils

Page {
    id: root

    property string pageUrl: "http://hotellook.com/"

    SilicaWebView {
        id: webView

        anchors.fill: parent

        url: pageUrl
    }
}
