var token = "acdea79c1af35e38e0e4855acd0b467d"
var marker = "81618"
var host = "harbour-ticket"

var baseUrl = "http://engine.hotellook.com"
var locations = baseUrl + "/api/v2/lookup.json?" //"query=prague&lang=en&lookFor=both&limit=10"
var hotel = baseUrl + "/api/v2/static/hotels.json?locationId="

//var getMyIpUrl = "http://ifconfig.me/ip" //"https://api.ipify.org?format=json"
// var getMyIpUrl = "http://ip-api.com/json"
var getMyIpUrl = "http://myip.dnsomatic.com/"

function performRequest(requestType, url, callback, params) {
    var request = new XMLHttpRequest()
    request.onreadystatechange = function() {
        if (request.readyState === 4) {
            if (request.status === 200) {
//                console.log("Data", request.responseText)
                callback(request.responseText)
            } else {
                console.log("Error status", request.status, request.statusText)
                console.log("Error", request.getAllResponseHeaders())
                console.log("Error", request.responseText)
                callback("error")
            }
        }
    }
    request.open(requestType, url)
    if(requestType === "GET") {
        request.setRequestHeader('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/21.0')
//        request.setRequestHeader('Content-type', 'application/x-www-form-urlencoded')
        request.setRequestHeader('Content-type', 'application/json')
//        Accept-Encoding: gzip, deflate, bzip2, compress
        request.setRequestHeader('Accept-Encoding', 'gzip, deflate, bzip2, compress, sdch')

    } else {
        request.setRequestHeader('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/21.0')
        request.setRequestHeader('Content-type', 'application/json')
    }
    console.log("send url", url)
    if (params) {
        var str = JSON.stringify(params)
        console.log("params", str)
        request.send(str)
    } else {
        request.send()
    }
}

function performRequest1(requestType, url, callback, params) {
    var request = new XMLHttpRequest()
    request.onreadystatechange = function() {
        if (request.readyState === 4) {
            if (request.status === 200) {
                callback(request.responseText)
            } else {
                console.log("Error status", request.status, request.statusText)
                console.log("Error", request.getAllResponseHeaders())
                console.log("Error", request.responseText)
                callback("error")
            }
        }
    }
    request.open(requestType, url)
    if(requestType === "GET") {
        request.setRequestHeader('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/21.0')
//        request.setRequestHeader('Content-type', 'application/x-www-form-urlencoded')
        request.setRequestHeader('Content-type', 'application/json')
//        Accept-Encoding: gzip, deflate, bzip2, compress
        request.setRequestHeader('Accept-Encoding', 'gzip, deflate, bzip2, compress, sdch')

    } else {
        request.setRequestHeader('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/21.0')
        request.setRequestHeader('Content-type', 'application/json')
    }
    console.log("send url", url)
    if (params) {
        var str = JSON.stringify(params)
        console.log("params", str)
        request.send(str)
    } else {
        request.send()
    }
}

function loadLocalFile(location, callback) {
    var request = new XMLHttpRequest()
    request.onreadystatechange = function() {
        if (request.readyState === 4) {
            callback(request.responseText)
        }
    }
    request.open("GET", location)
    console.log("get file", location)
    request.send()
}

function fromUnixToLocalDateTime(unixFormat) {
    var date = new Date(unixFormat * 1000)
    return date.toLocaleDateString() + " " + date.toLocaleTimeString()
}

function getFullDate(date) {
    var result = date.getFullYear() + "-"
    if (date.getMonth() < 9) {
        result += "0" + (date.getMonth() + 1) + "-"
    } else {
        result += (date.getMonth() + 1) + "-"
    }
    if (date.getDate() < 10) {
        result += "0" + date.getDate()
    } else {
        result += date.getDate()
    }
    return result
}

function getShortDate(date) {
    var result = date.getFullYear() + "-"
    if (date.getMonth() < 10) {
        result += "0" + (date.getMonth() + 1)
    } else {
        result += (date.getMonth() + 1)
    }
    return result
}

function sortDict(dict) {
    var sorted = []
    for(var key in dict) {
        sorted[sorted.length] = key
    }
    sorted.sort()
    var res = []
    for (var i in sorted) {
        if(typeof dict[sorted[i]] === "object") {
            var tmp = dict[sorted[i]]
            var tmpArr = sortDict(tmp)
            for (var j in tmpArr) {
                res[res.length] = tmpArr[j]
            }
        } else {
            res[res.length] = dict[sorted[i]]
        }
    }

    return res
}

function createMD5(data) {
    var result =  sortDict(data)
    result.splice(0, 0, marker)
    result.splice(0, 0, token)
    var str = result.join(":")
    console.log(str)
    var md5sum = Qt.md5(str)
    return md5sum
}

function onlyUnique(value, index, self) {
    return self.indexOf(value) === index
}

function setCheckoutDate(startDate, days) {
    var d = parseInt(days)
    console.log("start date", startDate, "days", d)
    var result = new Date(startDate)
    console.log("res date before", result, "get date", result.getDate())
    result.setDate(result.getDate() + d)
    console.log("res date after", result)
    return result
}

function getLangCode(key) {
    var d = ["en_US", "en_GB", "en_AU", "en_CA", "en_IE", "ru_RU", "de_DE", "es_ES", "fr_FR", "it_IT", "pl_PL", "th_TH"]
    if (key <= d.length) {
        return d[key]
    }
    return "en_US"
}

function getCurrencyCode(key) {
    var d = ["USD", "EUR", "RUB"]
    if (key <= d.length) {
        return d[key]
    }
    return "EUR"
}
