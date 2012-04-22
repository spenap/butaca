/**************************************************************************
 *    Butaca
 *    Copyright (C) 2011 Simon Pena <spena@igalia.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 **************************************************************************/

.pragma library

var PERSON = 0
var MOVIE = 1

var IMDB_BASE_URL = 'http://www.imdb.com/title/'

var REMOTE_FETCH_RESPONSE = 0
var EXTRAS_FETCH_RESPONSE = 1
var LOOKUP_FETCH_RESPONSE = 2

/**
 * Gets the year from a string containing a date
 *
 * @param {string} A date in a format yyyy-mm-dd
 * @return {string} The year component for the given date or a ' - '
 * for incorrect dates
 */
function getYearFromDate(date) {
    /* This asumes a date in yyyy-mm-dd */
    if (date) {
        var dateParts = date.split('-');
        return dateParts[0]
    }
    return ' - '
}

/**
 * Gets an url pointing to a thumbnail for the given trailer
 *
 * @param {string} The trailer url. It expects Youtube urls
 * @return {string} The url of the thumbnail for the trailer
 */
function getTrailerThumbnail(trailerUrl) {
    if (trailerUrl) {
        var THUMB_SIZE = '/1.jpg'
        var idFirstIndex = trailerUrl.indexOf('=')
        var idLastIndex = trailerUrl.lastIndexOf('&')
        var videoId = idLastIndex > idFirstIndex ?
                trailerUrl.substring(idFirstIndex + 1, idLastIndex) :
                trailerUrl.substring(idFirstIndex + 1)
        return 'http://img.youtube.com/vi/' + videoId + THUMB_SIZE
    }
    return ''
}

/**
 * Processes a text to remove undesirable HTML tags
 * @param {string} text with the HTML tags
 * @return {string} Text with only the newline tags respected
 */
function sanitizeText(text) {
    // "Save" existing <br /> into &lt;br /&gt;, remove all tags
    // and put the <br /> back there
    return text.replace(/<br \/>/g, '&lt;br /&gt;').replace(/<.*?>/g, '').replace(/&lt;br \/&gt;/g, '<br />')
}

function TMDbMovie(obj) {
    this.id = obj.id
    this.imdb_id = obj.imdb_id
    this.name = obj.name
    this.original_name = obj.original_name
    this.released = obj.released
    this.rating = obj.rating
    this.votes = obj.votes
    this.overview = obj.overview
    this.poster = obj.poster

    this.title = this.name
    this.type = 'TMDbMovie'

    this.toString = movie_toString
}

function TMDbPerson(obj) {
    this.id = obj.id
    this.name = obj.name
    this.biography = obj.biography
    this.url = obj.url
    this.image = obj.image

    this.title = this.name
    this.type = 'TMDbPerson'
}

function movie_toString() {
    var str = 'TMDB Movie:' +
            '\tid: ' + this.id + '\n' +
            '\tname: ' + this.name + '\n' +
            '\treleased: ' + this.released + '\n' +
            '\trating: ' + this.rating + '\n' +
            '\tvotes: ' + this.votes + '\n' +
            '\toverview: ' + this.overview + '\n' +
            '\tposter: ' + this.poster
    return str
}

function TMDbCrewPerson(obj) {
    // {
    //  "name":"Frank Miller",
    //  "job":"Director",
    //  "department":"Directing",
    //  "character":"",
    //  "id":2293,
    //  "order":0,
    //  "cast_id":1,
    //  "url":"http://www.themoviedb.org/person/2293",
    //  "profile":"http://cf2.imgobject.com/t/p/w185/hGijoL2duWMX4LohvgpkH9HpMq4.jpg"
    //  }
    this.id = obj.id
    this.name = obj.name
    this.job = obj.job
    this.department = obj.department
    this.character = obj.character
    this.order = obj.order
    this.castId = obj.cast_id
    this.url = obj.url
    this.profile = obj.profile
}

function TMDbImage(obj) {
    this.id = obj.image.id
    this.type = obj.image.type
    this.sizes = {
        'thumb' : { 'width' : 0, 'height': 0, 'url': ''},
        'w154' : { 'width' : 0, 'height': 0, 'url': ''},
        'profile' : { 'width' : 0, 'height': 0, 'url': ''},
        'cover' : { 'width' : 0, 'height': 0, 'url': ''},
        'w342' : { 'width' : 0, 'height': 0, 'url': ''},
        'mid' : { 'width' : 0, 'height': 0, 'url': ''},
        'h632' : { 'width' : 0, 'height': 0, 'url': ''},
        'original' : { 'width' : 0, 'height': 0, 'url': ''},
    }

    this.sizes[obj.image.size].width = obj.image.width
    this.sizes[obj.image.size].height = obj.image.height
    this.sizes[obj.image.size].url = obj.image.url
    this.addSize = image_addSize
}

function image_addSize(obj) {
    this.sizes[obj.size].width = obj.width
    this.sizes[obj.size].height = obj.height
    this.sizes[obj.size].url = obj.url
}

function populateModelFromModel(sourceModel, destinationModel, ObjectConstructor) {
    if (sourceModel.count > 0) {
        for (var i = 0; i < sourceModel.count; i ++) {
            destinationModel.append(new ObjectConstructor(sourceModel.get(i)))
        }
    }
}

function populateModelFromArray(entity, entityProperty, model, filterRules) {
    model.clear()
    if (filterRules) filterRules.secondaryModel.clear()
    if (entity && entity[entityProperty]) {
        for (var i = 0; i < entity[entityProperty].length; i ++) {
            if (filterRules) {
                var theObject = new filterRules.Delegate(entity[entityProperty][i])
                if (theObject[filterRules.filteringProperty] === filterRules.filteredValue) {
                    filterRules.secondaryModel.append(theObject)
                }
                model.append(theObject)
            } else {
                model.append(entity[entityProperty][i])
            }
        }
    }
}

function populateImagesModelFromArray(entity, entityProperty, model) {
    var i = 0
    var image
    model.clear()
    if (entity && entity[entityProperty]) {
        while (i < entity[entityProperty].length) {
            if (image && image.id === entity[entityProperty][i].image.id) {
                image.addSize(entity[entityProperty][i].image)
            } else {
                if (image) model.append(image)
                image = new TMDbImage(entity[entityProperty][i])
            }
            i ++
        }
    }
}

function parseDate(date) {
    if (date) {
        var dateParts = date.split('-')
        var parsedDate = new Date(dateParts[0], dateParts[1] - 1, dateParts[2])
        return parsedDate
    }
    return ''
}

function parseRuntime(runtime) {
    var hours = parseInt(runtime / 60)
    var minutes = (runtime % 60)

    var str = hours + ' h ' + minutes + ' m'
    return str
}

function asyncQuery(message, callback_function) {
    var xhr = new XMLHttpRequest
    xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE && callback_function) {
                    callback_function({
                                          action: message.response_action,
                                          response: xhr.responseText
                                      })
                }
            }
    xhr.open('GET', message.url)
    xhr.send()
}
