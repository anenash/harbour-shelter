import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Page {
    property string searchType: "city"
    property string searchUrl
    property string filterBy
    property string sortBy

    property string hotelTitle: ""

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
            console.log("searchType", searchType)
            if (searchType === "city") {
                Utils.performRequest("GET", searchUrl, getSearchId)
            } else {
                internal.url = searchUrl
                Utils.performRequest("GET", internal.url, getHotelInfo)
            }
        }
    }

    ListModel {
        id: hotels
    }

    function getSearchId(data) {
        if (data !== "error") {
            var parsed = JSON.parse(data)
            if (parsed.status === "ok") {
/*
http://engine.hotellook.com/api/v2/search/getResult.json?searchId=4034914&limit=10&sortBy=price&sortAsc=1&roomsCount=0&offset=0&marker=УкажитеВашМаркер&signature=364c38baee5cf11b382297bfd4338ce6
*/
                //"YourToken:YourMarker:limit:offset:roomsCount:searchId:sortAsc:sortBy".
                var t = {}
                t.limit = 25
                t.offset = 0
                t.sortBy = filterBy
                t.roomsCount = 0
                t.searchId = parsed.searchId
                t.sortAsc = sortBy

                var signature = Utils.createMD5(t)

                internal.url = Utils.baseUrl + "/api/v2/search/getResult.json?"
                internal.url += "searchId=" + t.searchId
                internal.url += "&limit=" + t.limit
                internal.url += "&offset=" + t.offset
                internal.url += "&sortBy=" + t.sortBy
                internal.url += "&roomsCount=" + t.roomsCount
                internal.url += "&sortAsc=" + t.sortAsc
                internal.url += "&marker=" + Utils.marker
                internal.url += "&signature=" + signature

                Utils.performRequest("GET", internal.url, getResults)
            }
        }
    }

    function getResults(data) {
        if (data !== "error") {
            timer.stop()
            var parsed = JSON.parse(data)
            if (parsed.status === "ok") {
                hotels.clear()
                for (var i in parsed.result) {
                    hotels.append({info: parsed.result[i], rooms: JSON.stringify(parsed.result[i].rooms)})
                    pageHeader.title = qsTr("Hotels list") + " (" + hotels.count + ")"
                }
            } else {
                message.text = parsed.message
                message.enabled = true
            }

            indicator.running = false
        } else {
            if (searchType === "city") {
                timer.start()
            }
        }
    }

    function getHotelInfo(data) {
        if (data !== "error") {
            var parsed = JSON.parse(data)
            if (parsed.status === "ok") {
                hotels.clear()
                if (parsed.result.length > 0) {
                    hotels.append({info: parsed.result[0], rooms: JSON.stringify(parsed.result[0].rooms)})
                    pageStack.replace(Qt.resolvedUrl("HotelInfoPage.qml"), {"hotelData": hotels.get(0).info, "hotelRooms": hotels.get(0).rooms})
                }
                indicator.running = false
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        PageHeader {
            id: pageHeader

            title: searchType === "city" ? qsTr("Hotels list") : hotelTitle
        }

        BusyIndicator {
            id: indicator

            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
        }

        SilicaListView {
            anchors.top: pageHeader.bottom
            anchors.topMargin: Theme.paddingSmall
            anchors.bottom: parent.bottom
            width: parent.width
            clip: true

            model: hotels
            delegate: HotelInfoDelegate {
                hotelData: info
                hotelRooms: rooms
                currency: database.currency
            }

            footer: Button {
                visible: searchType === "city" && hotels.count > 0 && !indicator.running
                width: parent.width
                text: "Load more hotels"
            }

            ViewPlaceholder {
                enabled: hotels.count == 0 && !indicator.running
                text: qsTr("No hotels found")
                hintText: qsTr("Please, change dates or hotel")
            }
        }

        ViewPlaceholder {
            id: message

            anchors.centerIn: parent
            enabled: false
        }
    }
}
