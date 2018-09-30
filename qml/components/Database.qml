import QtQuick 2.6
import QtQuick.LocalStorage 2.0 as Sql

Item {
    id: root

    property variant record

    property string language
    property string currency

    property bool showHints
    property int  openIn

    signal favorites()

    Component.onCompleted: {
        initDatabase()

        var curr = getName("currency")
        if (!curr) {
            curr = "EUR"
            storeData("currency", 0, "EUR")
        }
        currency = curr

        var lang = getName("language")
        if (!lang) {
            lang = "en_US"
            storeData("language", 0, "en_US")
        }
        language = lang

        var fltr = getValue("filter")
        if (!fltr) {
            storeData("filter", 0, "name")
        }

        if (getName("filter" === "")) {
            var i = getValue("filter")
            storeData("filter", i, "name")
        }

        var srt = getValue("sort")
        if (!srt) {
            storeData("sort", 0, "")
        }

        var hnt = getValue("hints")
        if (!hnt) {
            hnt = true
            storeData("hints", 0, hnt)
        }
        showHints = hnt

        var opnLnk = getValue("links")
        if (!opnLnk) {
            opnLnk = 0
            storeData("links", 0, opnLnk)
        }
        openIn = opnLnk
    }

    QtObject {
        id: internal

        // reference to the database object
        property var _db
    }

    function initDatabase() {
        // initialize the database object
        console.log('initDatabase()')
        internal._db = Sql.LocalStorage.openDatabaseSync("HotelsBooking", "1.0", "HotelsBooking settings SQL database", 1000000)
        internal._db.transaction( function(tx) {
            // Create the database if it doesn't already exist
            console.log("Create the database if it doesn't already exist")
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(keyname TEXT UNIQUE, value TEXT, textName TEXT)')
            tx.executeSql('CREATE TABLE IF NOT EXISTS favorites(keyname TEXT UNIQUE, value TEXT)')
        })
    }

    function storeData(keyname, value, textName) {
        // stores data to _db
        console.log('storeData()', keyname, value, textName)
        if(!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?,?);', [keyname,value,textName])
            if(result.rowsAffected === 1) {// use update
                console.log('record exists, update it')
            }
        })
    }

    function getValue(keyname) {
        console.log('getValue()', keyname)
        var res
        if(!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('SELECT value from settings WHERE keyname=?', [keyname])
            if(result.rows.length === 1) {// use update
                res = result.rows.item(0).value
            }
        })
        return res
    }

    function getName(keyname) {
        console.log('getName()', keyname)
        var res
        if(!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('SELECT textName from settings WHERE keyname=?', [keyname])
            if(result.rows.length === 1) {// use update
                res = result.rows.item(0).textName
                console.log("tx result", res)
            }
        })
        return res
    }

    function storeFavorite(keyname, value) {
        console.log('storeFavorite()', value)
        if(!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('INSERT OR REPLACE INTO favorites VALUES (?,?);', [keyname,value])
            if(result.rowsAffected === 1) {// use update
                console.log('record exists, update it')
            }
        })
        root.favorites()
    }

    function getFavorite(keyname) {
        console.log('getFavorite()', keyname)
        var res
        if(!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('SELECT value from favorites WHERE keyname=?', [keyname])
            if(result.rows.length === 1) {// use update
                res = result.rows.item(0).value
            }
        })
        return res
    }

    function getFavorites() {
        console.log('getFavorites()')
        var res = []
        if(!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('SELECT value FROM favorites')
//            console.log(result, JSON.stringify(result))
            for(var i = 0; i < result.rows.length; i++) {
                res.push(result.rows.item(i).value)
            }
        })
        return res
    }

    function deleteFavorite(keyname) {
        console.log('deleteFavorite()', keyname)
        var res = ""
        if(!internal._db) { return }
        internal._db.transaction( function(tx) {
            res = tx.executeSql('DELETE FROM favorites WHERE keyname=?', [keyname])
//            console.log("Resut", JSON.stringify(res))
        })
        return res
    }

    function dropFavorites() {
        console.log('dropFavorites()')
        if(!internal._db) { return }
        internal._db.transaction( function(tx) {
            tx.executeSql('DROP TABLE favorites')
            tx.executeSql('CREATE TABLE IF NOT EXISTS favorites(keyname TEXT UNIQUE, value TEXT)')
        })
        root.favorites()
    }
}
