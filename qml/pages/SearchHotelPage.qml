import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils


Page {
    property string searchUrl
    property string filterBy
    property string sortBy


    QtObject {
        id: internal

        property string url: ""
    }

    Database {
        id: database
    }

    Timer {
        id: timer

        interval: 6000
        repeat: true

        onTriggered: {
            Utils.performRequest("GET", internal.url, getResults)
        }
    }

    Component.onCompleted: {
        if (searchUrl) {
            indicator.running = true
            Utils.performRequest("GET", searchUrl, getSearchId)
        }
    }
}
