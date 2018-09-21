import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Page {
    id: root

    Database {
        id: database
    }

    Component.onCompleted: {
        /*
http://yasen.hotellook.com/tp/public/widget_location_dump.json?currency=rub&language=ru&limit=5&id=12209&type=popularity&check_in=2017-02-02&check_out=2017-02-17&token=Укажите_здесь_ваш_токен
*/
//        var checkin = Utils.getFullDate(new Date())
//        var checkout = Utils.getFullDate(Utils.setCheckoutDate(new Date(), "2"))
//        var lang = database.language.substring(0,2)
//        var cur = database.currency.toLowerCase()
//        var url = "http://yasen.hotellook.com/tp/public/widget_location_dump.json?"
//        url += "currency=" + cur
//        url += "&language=" + lang
//        url += "&limit=10"
//        url += "&id=6557"
//        url += "&type=popularity"
//        url += "&check_in=" + checkin
//        url += "&check_out=" + checkout
//        url += "&token=" + Utils.token

//        Utils.performRequest("GET", url, getData)
    }


    function getData(data) {

        if (data !== "error") {
//            console.log(data)
            var parsed = JSON.parse(data)
            for (var i in parsed.popularity) {
                favoritesModel.append(parsed.popularity[i])
            }
        }
    }

    ListModel {
        id: favoritesModel
    }

    ListModel {
        id: searchTypesList

        ListElement {
            type: "hotel"
            name: qsTr("Search by hotel name")
            descr: qsTr("Search by hotel name")
            image: "image://theme/icon-m-home"
        }
        ListElement {
            type: "city"
            name: qsTr("Search by city")
            descr: qsTr("Search by city")
            image: "image://theme/icon-m-location"
        }
        ListElement {
            type: "coordinates"
            name: qsTr("Search by coordinates")
            descr: qsTr("Search by coordinates")
            image: "image://theme/icon-m-gps"
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        PageHeader {
            id: head
            title: qsTr("Hotel booking")
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
//            MenuItem {
//                text: qsTr("Search")
//                onClicked: {
//                    pageStack.push(Qt.resolvedUrl("SearchPage.qml"))
//                }
//            }
            MenuItem {
                text: "Map"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("MapPage.qml"))
                }
            }
        }

        ListView {
            id: searchTypes

            anchors.top: head.bottom
//            anchors { top: head.bottom; left: parent.left; right: parent.right/*; bottom: parent.bottom*/}
            height: (Theme.itemSizeMedium + Theme.paddingMedium) * searchTypesList.count
            width: parent.width
            spacing: Theme.paddingMedium
            interactive: false
            model: searchTypesList
            delegate: IconTextSwitch {
                automaticCheck: false
                text: name
                icon.source: image
                description: descr
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SearchPage.qml"), {searchType: type})
                }
            }

        }

        //    *** FAVORITES ***
//        SilicaListView {
//            id: favoritesListView

//            anchors { top: head.bottom; left: parent.left; right: parent.right; bottom: parent.bottom}

//            spacing: Theme.paddingSmall
//            clip: true
//            //                visible: !busyIndicator.running
//            header: SectionHeader {
//                text: qsTr("Search history")
//            }

//            model: favoritesModel
//            delegate: HotelInfoDelegate {
//                hotelData: favoritesModel.get(index)
//            }
//            footer: ListItem {
//                contentHeight: Theme.itemSizeMedium
//                Label {
//                    anchors.centerIn: parent
//                    text: qsTr("New search")
//                }
//                onClicked: {
//                    pageStack.push(Qt.resolvedUrl("SearchPage.qml"))
//                }
//            }

//        }

    }
}
