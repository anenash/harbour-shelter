import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Page {
    id: root

    property string searchType: "city"
    property string searchUrl
    property string filterBy
    property string sortBy

    property string checkinDate
    property string checkoutDate

    property string hotelTitle: ""

    QtObject {
        id: internal

        property string url: ""
        property string searchId
        property int resultsLimit: 25
        property int offset: 0
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
                t.limit = internal.resultsLimit
                t.offset = internal.offset
                t.sortBy = filterBy
                t.roomsCount = 0
                t.searchId = parsed.searchId
                t.sortAsc = sortBy

                internal.searchId = parsed.searchId

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

    function getNextResults() {
        headIndicator.running = true
        internal.offset += 1
        var t = {}
        t.limit = 25
        t.offset = internal.offset
        t.sortBy = filterBy
        t.roomsCount = 0
        t.searchId = internal.searchId
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

    function getResults(data) {
        if (data !== "error") {
            timer.stop()
            var parsed = JSON.parse(data)
            if (parsed.status === "ok") {
                if (internal.offset == 0) {
                    hotels.clear()
                }
                for (var i in parsed.result) {
                    hotels.append({info: parsed.result[i], rooms: JSON.stringify(parsed.result[i].rooms)})
                    pageHeader.title = qsTr("Hotels list") + " (" + hotels.count + ")"
                }
            } else {
                message.text = parsed.message
                message.enabled = true
            }
            headIndicator.running = false
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
                    console.log("\n\n", parsed.result[0], "\n\n")
                    hotels.append({info: parsed.result[0], rooms: JSON.stringify(parsed.result[0].rooms)})
                    pageStack.replace(Qt.resolvedUrl("HotelInfoPage.qml"), {
                                          "hotelData": hotels.get(0).info,
                                          "hotelRooms": hotels.get(0).rooms,
                                          checkinDate: root.checkinDate,
                                          checkoutDate: root.checkoutDate
                                      })
                }
                indicator.running = false
            }
        }
    }

    function getNextButtonEnabled() {
        return hotels.count >= (internal.resultsLimit * (internal.offset + 1))
    }

    SilicaFlickable {
        anchors.fill: parent

        PageHeader {
            id: pageHeader

            title: searchType === "city" ? qsTr("Hotels list") : hotelTitle

            BusyIndicator {
                id: headIndicator

                anchors.left: parent.left
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                size: BusyIndicatorSize.Small
            }
        }

        BusyIndicator {
            id: indicator

            anchors.centerIn: parent
            size: BusyIndicatorSize.Large

            ViewPlaceholder {
                anchors.top: parent.bottom
                enabled: indicator.running
                text: qsTr("Please wait.\nSearch can take about 30 - 40 seconds")
            }
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
                checkinDate: root.checkinDate
                checkoutDate: root.checkoutDate
            }

            footer: Button {
                visible: searchType === "city" && !indicator.running && getNextButtonEnabled()
                width: parent.width
                text: "Load more hotels"

                onClicked: {
                    getNextResults()
                }
            }

            ViewPlaceholder {
                enabled: hotels.count == 0 && !indicator.running
                text: qsTr("No hotels found")
                hintText: qsTr("Please, change date or hotel")
            }
        }

        ViewPlaceholder {
            id: message

            anchors.centerIn: parent
            enabled: false
        }
    }
}
