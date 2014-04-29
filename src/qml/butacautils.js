/**************************************************************************
 *   Butaca
 *   Copyright (C) 2011 - 2012 Simon Pena <spena@igalia.com>
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
var TV = 2

var IMDB_BASE_URL = 'http://www.imdb.com/'

var FETCH_RESPONSE_TMDB_MOVIE = 0
var FETCH_RESPONSE_TMDB_PERSON = 1

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
 * Gets the Date object from a string containing a date
 *
 * @param {string} A date in a format yyyy-mm-dd
 * @return {Date} the Date object
 */
function getDateFromString(date) {
    /* This asumes a date in yyyy-mm-dd */
    if (date) {
        var dateParts = date.split('-');
        return new Date(dateParts[0],
                        dateParts[1] - 1, // months are 0-based
                        dateParts[2])
    }
    return ''
}

/**
 * gets the difference in days between two given dates
 *
 * @param {Date} A date object
 * @param {Date} Another date object
 * @return {int} the difference in days
 */
function dateDiffInDays(a, b) {
    // Discard the time and time-zone information.
    var utc1 = Date.UTC(a.getFullYear(), a.getMonth(), a.getDate());
    var utc2 = Date.UTC(b.getFullYear(), b.getMonth(), b.getDate());

    return Math.floor((utc2 - utc1) / (1000 * 60 * 60 * 24));
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

/**
 * basic content of TMDB movie/TV/person that is passed around from view to view
 */
function TMDBObject(obj) {
    this.id = obj.id
    this.name = obj.name || obj.title
    this.img = obj.poster_path || obj.profile_path
}

function TMDbCredit(obj) {
    this.base = TMDBObject
    this.base(obj)

    this.credit_id = obj.credit_id
    this.department = obj.department || 'Actors'
    this.subtitle = obj.job || obj.character
}

function TMDbFilmography(obj) {
    this.base = TMDBObject
    this.base(obj)

    this.department = obj.department || 'Acting'
    this.subtitle = obj.character || obj.job || ''
    this.date = obj.release_date || obj.first_air_date
}

function TMDbFilmographyTv(obj) {
    this.base = TMDbFilmography
    this.base(obj)

    this.type = 'TMDbFilmographyTv'
}

function TMDbFilmographyMovie(obj) {
    this.base = TMDbFilmography
    this.base(obj)

    this.type = 'TMDbFilmographyMovie'
}

function TMDBSearchresult(obj) {
    this.base = TMDBObject
    this.base(obj)

    this.date = obj.release_date || obj.first_air_date || ''
    this.vote_avg = obj.vote_average || ''
    this.vote_cnt = obj.vote_count || ''
}

function populateModelFromModel(sourceModel, destinationModel, ObjectConstructor) {
    if (sourceModel.count > 0) {
        for (var i = 0; i < sourceModel.count; i ++) {
            destinationModel.append(new ObjectConstructor(sourceModel.get(i)))
        }
    }
}

function populateModelFromArray(entity, model) {
    if (entity) {
        for (var i = 0; i < entity.length; i ++) {
            model.append(entity[i])
        }
    }
}

function populateArrayFromArray(srcArray, dstArray, ObjectConstructor) {
    if (srcArray) {
        for (var i = 0; i < srcArray.length; i ++) {
            dstArray.push(new ObjectConstructor(srcArray[i]))
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
