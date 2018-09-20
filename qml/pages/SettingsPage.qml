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
                    text: "US dollar"
                }
                MenuItem {
                    text: "EU euro"
                }
                MenuItem {
                    text: "Rubl"
                }
            }
            onCurrentIndexChanged: {
                var code = Utils.getCurrencyCode(curr.currentIndex)
                database.storeData("currency", curr.currentIndex, code)
            }
        }

        /*
Австралийский доллар (AUD);
Азербайджанский манат (AZN);
Белорусский рубль (BYR);
Канадский доллар (CAD);
Швейцарский франк (CHF);
Китайский юань (CNY);
Египетский фунт (EGP);
Евро (EUR);
Фунт стерлингов (GPB);
Гонконгский доллар (HKD);
Индонезийская рупия (IDR);
Индийская рупия (INR);
Норвежская крона (KOK);
Казахстанский тенге (KZT);
Литовский лит (LTL);
Новозеландский доллар (NZD);
Филиппинское песо (PHP);
Пакистанская рупия (PKR);
Российский рубль (RUB);
Сингапурский доллар (SGD);
Тайский бат (THB);
Украинская гривна (UAH);
Доллар США (USD);
Южноафриканский ранд (ZAR).
*/
    }
}
