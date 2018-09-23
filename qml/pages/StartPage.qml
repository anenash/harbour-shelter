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
        getData()
    }


    function getData() {

        var fav = database.getFavorites()
        if (fav.length > 0) {
            for (var i in fav) {
                var parsed = JSON.parse(fav[i])
                favoritesModel.append(parsed)
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
        }

        ListView {
            id: searchTypes

            anchors.top: head.bottom
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
        SilicaListView {
            id: favoritesListView

            anchors { top: searchTypes.bottom; left: parent.left; right: parent.right; bottom: parent.bottom}

            spacing: Theme.paddingSmall
            clip: true
            //                visible: !busyIndicator.running
            header: SectionHeader {
                text: qsTr("Search history")
            }

            model: favoritesModel
            delegate: HotelInfoDelegate {
                enabled: false
                hotelData: favoritesModel.get(index)
            }

            ViewPlaceholder {
                enabled: favoritesModel.count == 0
                text: "No items yet"
                hintText: "Search hotel to add items"
            }

        }

    }
}
