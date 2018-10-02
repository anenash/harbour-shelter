import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Page {

    Database {
        id: database
    }

    QtObject {
        id: internal

    }

    Component.onCompleted: {
        lang.currentIndex = database.getValue("language")
        curr.currentIndex = database.getValue("currency")
        links.currentIndex = database.getValue("links")
    }

    Column {
        anchors.fill: parent

        PageHeader{
            title: qsTr("Settings")
        }

        SectionHeader {
            text: qsTr("Language:")
        }

        ComboBox {
            id: lang

            label: qsTr("Language of the search result")

            menu: ContextMenu {
                MenuItem {
                    text: "English (US)"
                }
                MenuItem {
                    text: "English (GB)"
                }
                MenuItem {
                    text: "English (AU)"
                }
                MenuItem {
                    text: "English (CA)"
                }
                MenuItem {
                    text: "English (IE)"
                }
                MenuItem {
                    text: "Russian"
                }
                MenuItem {
                    text: "Germany"
                }
                MenuItem {
                    text: "Spain"
                }
                MenuItem {
                    text: "France"
                }
                MenuItem {
                    text: "Italy"
                }
                MenuItem {
                    text: "Poland"
                }
                MenuItem {
                    text: "Swedish"
                }
                MenuItem {
                    text: "Thailand"
                }
            }
            onCurrentIndexChanged: {
                var code = Utils.getLangCode(lang.currentIndex)
                database.storeData("language", lang.currentIndex, code)
            }
        }

        SectionHeader {
            text: qsTr("Currency:")
        }


        ComboBox {
            id: curr

            label: qsTr("Get results in currency")

            menu: ContextMenu {
                MenuItem {
                    text: "USD"
                }

                MenuItem {
                    text: "EUR"
                }

                MenuItem {
                    text: "RUB"
                }

                MenuItem {
                    text: "GPB"
                }

                MenuItem {
                    text: "SEK"
                }

                MenuItem {
                    text: "AUD"
                }

                MenuItem {
                    text: "AZN"
                }

                MenuItem {
                    text: "BYR"
                }

                MenuItem {
                    text: "CAD"
                }

                MenuItem {
                    text: "CHF"
                }

                MenuItem {
                    text: "CNY"
                }

                MenuItem {
                    text: "EGP"
                }

                MenuItem {
                    text: "HKD"
                }

                MenuItem {
                    text: "IDR"
                }

                MenuItem {
                    text: "INR"
                }

                MenuItem {
                    text: "KOK"
                }

                MenuItem {
                    text: "KZT"
                }

                MenuItem {
                    text: "LTL"
                }

                MenuItem {
                    text: "NZD"
                }

                MenuItem {
                    text: "PHP"
                }

                MenuItem {
                    text: "PKR"
                }

                MenuItem {
                    text: "SGD"
                }

                MenuItem {
                    text: "THB"
                }

                MenuItem {
                    text: "UAH"
                }

                MenuItem {
                    text: "ZAR"
                }
            }
            onCurrentIndexChanged: {
                database.storeData("currency", curr.currentIndex, curr.currentItem.text)
            }
        }

        SectionHeader {
            text: qsTr("Options")
        }

        ComboBox {
            id: links

            label: qsTr("Open booking link in")

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("internal webview")
                }
                MenuItem {
                    text: qsTr("external browser")
                }
            }
            onCurrentIndexChanged: {
                database.storeData("links", links.currentIndex, links.currentIndex)
            }
        }

        TextSwitch {
            id: hints

            text: qsTr("Show hints")
            checked: database.getName("hints") == "true"

            onCheckedChanged: {
                database.storeData("hints", 0, checked)
            }
        }

        StartScreenItem {
            id: dropFavs

            title: qsTr("Delete search history")
            iconSource: "image://theme/icon-m-delete"

            onClicked: {
                database.dropFavorites()
            }
        }
    }
}
