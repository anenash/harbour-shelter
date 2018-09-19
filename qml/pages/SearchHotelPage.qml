import QtQuick 2.6
import Sailfish.Silica 1.0

import app.utils 1.0

import "../components"
import "../components/Utils.js" as Utils

Dialog {

/*http://yasen.hotellook.com/tp/public/widget_location_dump.json?
  currency=rub&
language=de&
limit=200&
id=895&
type=5stars,distance&
check_in=2018-10-02&
check_out=2018-10-17&
token=acdea79c1af35e38e0e4855acd0b467d
*/
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

    function setCheckoutDate(days) {
        var result = new Date(internal.checkin)
        result.setDate(result.getDate() + days)
        internal.checkout = result
        return result
    }

    /*
"center",
"tophotels",
"highprice",
"luxury",
"3-stars",
"4-stars",
"5-stars",
"restaurant",
"pets",
"pool",
"smoke",
"river_view",
"cheaphotel_ufa",
"luxury_ufa",
"price",
"rating",
"distance",
"popularity",
"3stars",
"4stars",
"5stars"
*/
}
