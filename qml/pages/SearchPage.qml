import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Dialog {
    id: root

    property string searchType: "city"

    canAccept: internal.locationIsSet && internal.checkinIsSet

    QtObject {
        id: internal

        property variant location: ({})
        property date checkin: new Date()
        property date checkout: Utils.setCheckoutDate(checkin, "2")
        property bool locationIsSet: false
        property bool checkinIsSet: false
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

//    function setCheckoutDate(days) {
//        var result = new Date(internal.checkin)
//        result.setDate(result.getDate() + days)
//        internal.checkout = result
//        return result
//    }

    onAccepted: {
        var t = {}
        if (searchType === "city") {
            t.cityId = internal.location.id
        } else {
            t.hotelId = internal.location.id
        }

        t.checkIn = Utils.getFullDate(internal.checkin)
        t.checkOut = Utils.getFullDate(internal.checkout)
        t.adultsCount = adultsCount.text
        t.customerIP = app.myIp
        t.childrenCount = childsCount.text
        t.lang = database.language //"ru_RU"
        t.currency = database.currency //"USD"
        t.waitForResult = "0"

        var url = Utils.baseUrl + "/api/v2/search/start.json?"
        if (searchType === "city") {
            url += "cityId=" + internal.location.id
        } else {
            url += "hotelId=" + internal.location.id
        }
//        url += "cityId=" + internal.location.id
        url += "&checkIn=" + Utils.getFullDate(internal.checkin)
        url += "&checkOut=" + Utils.getFullDate(internal.checkout)
        url += "&adultsCount=" + adultsCount.text
        url += "&customerIP=" + app.myIp
        url += "&childrenCount=" + childsCount.text
        url += "&lang=" + database.language  //"ru_RU"
        url += "&currency=" + database.currency //"USD"
        url += "&waitForResult=0"
        url += "&marker=" + profileInfo.marker
        url += "&signature=" + Utils.createMD5(t)

        pageStack.push(Qt.resolvedUrl("ResultsPage.qml"), {searchUrl: url, filterBy: filter.currentItem.text, sortBy: sort.currentIndex})
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
                label: qsTr("Location: ")
                value: qsTr("Select")

                onClicked: {
                    if (searchType !== "coordinates") {
                        var dialog = pageStack.push(searchDialog, {requestType: searchType})

                        dialog.accepted.connect(function() {
                            console.log("location info", JSON.stringify(dialog.result))
                            internal.location = dialog.result
                            value = dialog.result.fullName
                            internal.locationIsSet = true
                        })
                    } else {
                        var coord = pageStack.push(Qt.resolvedUrl("MapPage.qml"))
                    }
                }
            }

            ValueButton {
                id: checkinDate

                label: qsTr("Check-in date: ")
                value: qsTr("Select")

                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog", {
                                                    date: new Date()
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

                menu: ContextMenu {
                    MenuItem { text: "name" }
                    MenuItem { text: "popularity" }
                    MenuItem { text: "price" }
                    MenuItem { text: "rating" }
                    MenuItem { text: "stars" }
                }
            }

            ComboBox {
                id: sort

                label: qsTr("Sort by")

                menu: ContextMenu {
                    MenuItem { text: qsTr("decrease") }
                    MenuItem { text: qsTr("increase") }
                }
            }
        }
    }
}
