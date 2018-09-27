import QtQuick 2.6
import Sailfish.Silica 1.0

import "../components/Utils.js" as Utils

Page {
    id: root

    property string pageUrl: "http://hotellook.com/"

    SilicaWebView {
        id: webView

        anchors.fill: parent

        header: ProgressBar {
            minimumValue: 0
            maximumValue: 100
            value: webView.loadProgress
            visible: webView.loading
        }

        url: pageUrl
    }
}
