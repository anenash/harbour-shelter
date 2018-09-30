import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Dialog {
    id: root

    property string searchType: "city"

    property alias hotelTitle: locationField.value
    property alias location: internal.location
    property alias locationIsSet: internal.locationIsSet


    canAccept: internal.locationIsSet && internal.checkinIsSet

    QtObject {
        id: internal

        property variant location: ({})
        property date checkin: new Date()
        property date checkout: Utils.setCheckoutDate(checkin, "2")
        property bool locationIsSet: false
        property bool checkinIsSet: false

        property string filterKey

        property real lat
        property real lon
    }

    Database {
        id: database
    }

    ProfileInfo {
        id: profileInfo
    }

    SearchDialog {
        id: searchDialog
    }

    Component {
        id: datePickerComponent
        DatePickerDialog {}
    }

    Timer {
        id: openLocation

        interval: 200

        onTriggered: {
            var dialog = pageStack.push(searchDialog, {requestType: searchType, lat: internal.lat, lon: internal.lon})

            dialog.accepted.connect(function() {
                console.log("location info", JSON.stringify(dialog.result))
                internal.location = dialog.result
                value = dialog.result.fullName
                internal.locationIsSet = true
            })
        }
    }

    Component.onCompleted: {
        sort.currentIndex = database.getValue("sort")
        filter.currentIndex = database.getValue("filter")
        internal.filterKey = database.getName("filter")
    }

    onAccepted: {
        var t = {}
        if (searchType === "city") {
            t.cityId = internal.location.id
            t.waitForResult = "0"
        } else {
            t.hotelId = internal.location.id
            t.waitForResult = "1"
        }

        t.checkIn = Utils.getFullDate(internal.checkin)
        t.checkOut = Utils.getFullDate(internal.checkout)
        t.adultsCount = adultsCount.text
        t.customerIP = app.myIp
        t.childrenCount = childsCount.text
        t.lang = database.language //"ru_RU"
        t.currency = database.currency //"USD"

        var url = Utils.baseUrl + "/api/v2/search/start.json?"
        if (searchType === "city") {
            url += "cityId=" + t.cityId
        } else {
            url += "hotelId=" + t.hotelId
        }
//        url += "cityId=" + internal.location.id
        url += "&checkIn=" + t.checkIn
        url += "&checkOut=" + t.checkOut
        url += "&adultsCount=" + t.adultsCount
        url += "&customerIP=" + t.customerIP
        url += "&childrenCount=" + t.childrenCount
        url += "&lang=" + t.lang
        url += "&currency=" + t.currency
        url += "&waitForResult=" + t.waitForResult
        url += "&marker=" + profileInfo.marker
        url += "&signature=" + Utils.createMD5(t)

        pageStack.push(Qt.resolvedUrl("ResultsPage.qml"), {"searchType": searchType,
                           searchUrl: url,
                           filterBy: internal.filterKey,
                           sortBy: sort.currentIndex,
                           hotelTitle: locationField.value,
                           checkinDate: t.checkIn,
                           checkoutDate: t.checkOut
                       })
    }


    SilicaFlickable {
        anchors.fill: parent


        DialogHeader {
            id: pageHeader

            acceptText: qsTr("Search")
            cancelText: qsTr("Cancel")
        }

        Column {
            anchors.top: pageHeader.bottom
            anchors.topMargin: Theme.paddingLarge
            width: parent.width

            ValueButton {
                id: locationField

                label: searchType !== "hotel"?qsTr("Location: "):qsTr("Hotel: ")
                value: qsTr("Select")

                onClicked: {
                    var dialog = pageStack.push(searchDialog, {requestType: searchType})

                    dialog.accepted.connect(function() {
                        console.log("location info", JSON.stringify(dialog.result))
                        internal.location = dialog.result
                        value = dialog.result.fullName
                        internal.locationIsSet = true
                    })
                }
            }

            ValueButton {
                id: checkinDate

                label: qsTr("Check-in date: ")
                value: qsTr("Select")

                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog", {
                                                    date: internal.checkin
                                                })

                    dialog.accepted.connect(function() {
                        internal.checkin = dialog.date
                        value = dialog.dateText
                        internal.checkout = Utils.setCheckoutDate(internal.checkin, daysCount.text)
//                        setCheckoutDate(parseInt(daysCount.text))
                        internal.checkinIsSet = true
                    })
                }
            }

            SectionHeader {
                text: qsTr("Nigths")
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                IconButton {
                    icon.source: "image://theme/icon-m-remove"
                    onClicked: {
                        decreaseValue()
                    }
                    onPressAndHold: {
                        decreaseValue()
                    }
                    function decreaseValue() {
                        var t = parseInt(daysCount.text)
                        if (t > 1) {
                            t = t - 1
                        }
                        daysCount.text = t
                        internal.checkout = Utils.setCheckoutDate(internal.checkin, t)
                    }
                }
                Label {
                    id: daysCount

                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.25
                    horizontalAlignment: Text.AlignHCenter
                    text: "2"
                }
                IconButton {
                    icon.source: "image://theme/icon-m-add"
                    onClicked: {
                        increaseValue()
                    }
                    onPressAndHold: {
                        increaseValue()
                    }
                    function increaseValue() {
                        var t = parseInt(daysCount.text)
                        if (t < 31) {
                            t = t + 1
                        }
                        daysCount.text = t
                        internal.checkout = Utils.setCheckoutDate(internal.checkin, t)
                    }
                }
            }


            //            ValueButton {
            //                id: checkoutDate

            //                label: qsTr("Check-out date: ")
            //                value: qsTr("Select")

            //                onClicked: {
            //                    var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog", {
            //                                                    date: new Date()
            //                                                })

            //                    dialog.accepted.connect(function() {
            //                        internal.checkout = dialog.date
            //                        value = dialog.dateText
            //                    })
            //                }
            //            }

            SectionHeader {
                text: qsTr("Adults count")
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                IconButton {
                    icon.source: "image://theme/icon-m-remove"
                    onClicked: {
                        var t = parseInt(adultsCount.text)
                        if (t > 1) {
                            t = t - 1
                        }
                        adultsCount.text = t
                    }
                }
                Label {
                    id: adultsCount

                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.25
                    horizontalAlignment: Text.AlignHCenter
                    text: "2"
                }
                IconButton {
                    icon.source: "image://theme/icon-m-add"
                    onClicked: {
                        var t = parseInt(adultsCount.text)
                        if (t < 4) {
                            t = t + 1
                        }
                        adultsCount.text = t
                    }
                }
            }

            SectionHeader {
                text: qsTr("Childs count")
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                IconButton {
                    icon.source: "image://theme/icon-m-remove"
                    onClicked: {
                        var t = parseInt(childsCount.text)
                        if (t > 0) {
                            t = t - 1
                        }
                        childsCount.text = t
                    }
                }
                Label {
                    id: childsCount

                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * 0.25
                    horizontalAlignment: Text.AlignHCenter
                    text: "0"
                }
                IconButton {
                    icon.source: "image://theme/icon-m-add"
                    onClicked: {
                        var t = parseInt(childsCount.text)
                        if (t < 3) {
                            t = t + 1
                        }
                        childsCount.text = t
                    }
                }
            }

            ComboBox {
                id: filter

                label: qsTr("Filter by")
                visible: searchType === "city"

                menu: ContextMenu {
                    MenuItem { text: filter.getFiter(0).title }
                    MenuItem { text: filter.getFiter(1).title }
                    MenuItem { text: filter.getFiter(2).title }
                    MenuItem { text: filter.getFiter(3).title }
                    MenuItem { text: filter.getFiter(4).title }
                }

                onCurrentIndexChanged: {
                    internal.filterKey = getFiter(currentIndex).key
                    database.storeData("filter", currentIndex, internal.filterKey)
                }

                function getFiter(index) {
                    var mapper = [
                        {key: "name", title: qsTr("Name")},
                        {key: "popularity", title: qsTr("Popularity")},
                        {key: "price", title: qsTr("Price")},
                        {key: "rating", title: qsTr("Rating")},
                        {key: "stars", title: qsTr("Stars")}
                    ]
                    return mapper[index]
                }
            }

            ComboBox {
                id: sort

                label: qsTr("Sort by")
                visible: searchType === "city"

                menu: ContextMenu {
                    MenuItem { text: qsTr("decrease") }
                    MenuItem { text: qsTr("increase") }
                }

                onCurrentIndexChanged: {
                    database.storeData("sort", currentIndex, "")
                }
            }
        }
    }
}
