import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Page {

    Database {
        id: database
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
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "en_US")
                    }
                }
                MenuItem {
                    text: "English (GB)"
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "en_GB")
                    }
                }
                MenuItem {
                    text: "English (AU)"
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "en_AU")
                    }
                }
                MenuItem {
                    text: "English (CA)"
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "en_CA")
                    }
                }
                MenuItem {
                    text: "English (IE)"
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "en_IE")
                    }
                }
                MenuItem {
                    text: "Russian"
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "ru_RU")
                    }
                }
                MenuItem {
                    text: "Germany"
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "de_DE")
                    }
                }
                MenuItem {
                    text: "Spain"
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "es_ES")
                    }
                }
                MenuItem {
                    text: "France"
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "fr_FR")
                    }
                }
                MenuItem {
                    text: "Italy"
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "it_IT")
                    }
                }
                MenuItem {
                    text: "Poland"
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "pl_PL")
                    }
                }
                MenuItem {
                    text: "Thailand"
                    onClicked: {
                        database.storeData("language", lang.currentIndex, "th_TH")
                    }
                }
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
                    onClicked: {
                        database.storeData("currency", curr.currentIndex, "USD")
                    }
                }
                MenuItem {
                    text: "EU euro"
                    onClicked: {
                        database.storeData("currency", curr.currentIndex, "EUR")
                    }
                }
                MenuItem {
                    text: "Rubl"
                    onClicked: {
                        database.storeData("currency", curr.currentIndex, "RUB")
                    }
                }
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
