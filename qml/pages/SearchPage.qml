import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Page {

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

    SilicaFlickable {
        anchors.fill: parent

        PageHeader {
            id: pageHeader

            title: qsTr("Hotel search")
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                }
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
                }
            }
            MenuItem {
                text: qsTr("Search")
                onClicked: {
//                    var dialog = pageStack.push(searchDialog)

//                    dialog.accepted.connect(function() {
//                        console.log("location info", JSON.stringify(dialog.result))
//                    })

/*
http://engine.hotellook.com/api/v2/search/start.json?
iata=HKT&checkIn=2018-08-10&checkOut=2018-08-13
&adultsCount=2&customerIP=100.168.1.1
&childrenCount=1&childAge1=8&lang=ru
&currency=USD&waitForResult=0
&marker=УкажитеВашМаркер&signature=a475100374414df97a9c6c7d7731b3c6
*/
/*
iata=HKT;
checkIn=2018-08-10;
checkOut=2018-08-13;
adultsCount=2;
customerIP=100.168.1.1;
childrenCount=1;
childAge1=8;
lang=ru;
currency=USD;
waitForResult=0.
*/
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

                    console.log(Utils.createMD5(t))

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
/*
http://engine.hotellook.com/api/v2/cache.json?location=Moscow&currency=rub&checkIn=2017-06-10&checkOut=2017-06-12&limit=10
*/

/*
  http://engine.hotellook.com/api/v2/static/hotels.json?locationId=895&token=УкажитеВашТокен
*//*
                    var url = Utils.baseUrl + "/api/v2/search/start.json?"//"/api/v2/cache.json?" // "/api/v2/static/hotels.json?"
//                    url += "locationId=" + internal.location.id

                    url += "iata=MOW"
                    url += "&currency=USD"
                    url += "&checkIn=" + Utils.getFullDate(internal.checkin)
                    url += "&checkOut=" + Utils.getFullDate(internal.checkout)
                    url += "&adults=" + adultsCount.text

                    url += "&token=" + profileInfo.token */

                    console.log(url)

                    pageStack.push(Qt.resolvedUrl("ResultsPage.qml"), {searchUrl: url, filterBy: filter.currentItem.text, sortBy: sort.currentIndex})
                }
            }
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
                label: qsTr("Check-in date: ")
                value: qsTr("Select")

                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog", {
                                                    date: new Date()
                                                })

                    dialog.accepted.connect(function() {
                        internal.checkin = dialog.date
                        value = dialog.dateText
                    })
                }
            }
            ValueButton {
                label: qsTr("Check-out date: ")
                value: qsTr("Select")

                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog", {
                                                    date: new Date()
                                                })

                    dialog.accepted.connect(function() {
                        internal.checkout = dialog.date
                        value = dialog.dateText
                    })
                }
            }
            SectionHeader {
                text: qsTr("Adults count")
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                IconButton {
                    icon.source: "image://theme/icon-m-left"
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
                    icon.source: "image://theme/icon-m-right"
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
                    icon.source: "image://theme/icon-m-left"
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
                    icon.source: "image://theme/icon-m-right"
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
                    MenuItem { text: "increase" }
                    MenuItem { text: "decrease" }
                }
            }
        }
    }
}
