.pragma library
Qt.include('butacautils.js')

WorkerScript.onMessage = function(message) {
            switch (message.action) {
            case REMOTE_FETCH_REQUEST:
                remoteFetch(message.tmdbId, message.tmdbType)
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
    xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    WorkerScript.sendMessage({
                                                 action: REMOTE_FETCH_RESPONSE,
                                                 response: xhr.responseText
                                             })
                }
            }
    xhr.open("GET", 'http://api.themoviedb.org/2.1/Movie.getInfo/en/json/249e1a42df9bee09fac5e92d3a51396b/' + id)
    xhr.send()
}
