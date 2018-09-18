import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Dialog {

    QtObject {
        id: internal

        property variant location: ({})
        property variant checkin: ({})
        property variant checkout: ({})
//        property variant city: ({})
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

    function setCheckoutDate(days) {
        var result = new Date(internal.checkin)
        result.setDate(result.getDate() + days)
        internal.checkout = result
        return result
    }

//    function getCitiesList(data) {
//        if (data !== "error") {
//            console.log(data)
//            var parsed = JSON.parse(data)
//            for (var i in parsed) {
//                city[parsed[i].name.EN[0].name] = parsed[i]
//            }
//        }
//    }

//    Component.onCompleted: {
//        var url = "http://engine.hotellook.com/api/v2/static/locations.json?token=" + profileInfo.token
//        Utils.performRequest("GET", url, getCitiesList)
//    }
    onAccepted: {
        var t = {}
        t.cityId = internal.location.id
        t.checkIn = Utils.getFullDate(internal.checkin)
        t.checkOut = Utils.getFullDate(internal.checkout)
        t.adultsCount = adultsCount.text
        t.customerIP = app.myIp
        t.childrenCount = childsCount.text
        t.lang = database.language //"ru_RU"
        t.currency = database.currency //"USD"
        t.waitForResult = "0"

        var url = Utils.baseUrl + "/api/v2/search/start.json?"
        url += "cityId=" + internal.location.id
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
                    var dialog = pageStack.push(searchDialog)

                    dialog.accepted.connect(function() {
                        console.log("location info", JSON.stringify(dialog.result))
                        internal.location = dialog.result
                        value = dialog.result.fullName
                    })
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
                        setCheckoutDate(parseInt(daysCount.text))
                    })
                }
            }

            SectionHeader {
                text: qsTr("Days")

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
                            setCheckoutDate(t)
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
                            setCheckoutDate(t)
                        }
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
            }


            SectionHeader {
                text: qsTr("Childs count")

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
