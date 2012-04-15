.pragma library
Qt.include('butacautils.js')

WorkerScript.onMessage = function(message) {
            switch (message.action) {
            case REMOTE_FETCH_REQUEST:
                remoteFetch(message.tmdbId, message.tmdbType)
                break
            case EXTRAS_FETCH_REQUEST:
                extrasFetch(message.movieName)
                break
            default:
                console.debug('Unknown action', message.action)
                break
            }
        }

function remoteFetch(id, type) {
    console.debug('TMDb ID:', id)
    console.debug('Element type:', type)
    var xhr = new XMLHttpRequest
    var url = type === 'movie' ?
                'http://api.themoviedb.org/2.1/Movie.getInfo/en/json/249e1a42df9bee09fac5e92d3a51396b/' :
                'http://api.themoviedb.org/2.1/Person.getInfo/en/json/249e1a42df9bee09fac5e92d3a51396b/'
    xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    WorkerScript.sendMessage({
                                                 action: REMOTE_FETCH_RESPONSE,
                                                 response: xhr.responseText
                                             })
                }
            }
    xhr.open("GET", url + id)
    xhr.send()
}

function extrasFetch(name) {
    var xhr = new XMLHttpRequest
    var url = 'http://aftercredits.com/api/get_search_results?search=' + name
    console.debug('Fetching extras from', url)
    xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    WorkerScript.sendMessage({
                                                 action: EXTRAS_FETCH_RESPONSE,
                                                 response: xhr.responseText
                                             })
                }
            }
    xhr.open("GET", url)
    xhr.send()
}
