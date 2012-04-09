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

/* TheMovieDb.org API-related stuff */
var TMDB_API_KEY = '249e1a42df9bee09fac5e92d3a51396b'
var TMDB_BASE_URL = 'http://api.themoviedb.org/2.1'
var TMDB_LANGUAGE = 'en'
var TMDB_FORMAT = 'xml'

/* Movie API */
var TMDB_MOVIE_SEARCH = 'Movie.search'
var TMDB_MOVIE_BROWSE = 'Movie.browse'
var TMDB_MOVIE_GET_INFO = 'Movie.getInfo'
var TMDB_MOVIE_QUERY = '/OpenSearchDescription/movies/movie'
var TMDB_MOVIE_CAST_QUERY = '/OpenSearchDescription/movies/movie/cast/person'

/* Person API */
var TMDB_PERSON_SEARCH = 'Person.search'
var TMDB_PERSON_GET_INFO = 'Person.getInfo'
var TMDB_PERSON_QUERY = '/OpenSearchDescription/people/person'
var TMDB_PERSON_FILMOGRAPHY_QUERY = '/OpenSearchDescription/people/person/filmography/movie'

/* Genres API */
var TMDB_GENRES_GET_LIST = 'Genres.getList'
var TMDB_GENRES_QUERY = '/OpenSearchDescription/genres/genre'

var PERSON = 0
var MOVIE = 1

var IMDB_BASE_URL = 'http://www.imdb.com/title/'

var REMOTE_FETCH_REQUEST = 0
var REMOTE_FETCH_RESPONSE = 0

/**
 * Builds the source for a model using TMDb services.
 *
 * @param {string} the api method of choice
 * @param {string} the language to get the content in
 * @param {params} additional params to build the query
 * @return {string} the string with the source
 */
function getTMDbSource(apiMethod, lang, params) {

    // BASE_URL + API_METHOD + LAN + FORMAT + API_KEY + PARAMS

    var source = TMDB_BASE_URL + '/' + apiMethod +
        '/' + lang +
        '/' + TMDB_FORMAT +
        '/' + TMDB_API_KEY
    if (params !== '') {
        source += (params.charAt(0) == '?' ? params + '&page=1' : '/' + params)
    }
    return source
}

/**
 * Gets the browse criteria given a genre
 *
 * @param {string} order criteria (rating, title, release)
 * @param {string} sort order (asc, desc)
 * @param {string} results per page
 * @param {string} minimum votes
 * @param {string} genre to use for browsing
 *
 * @return {string} browse criteria
 */
function getBrowseCriteria(orderBy, order, perPage, minVotes, genreId) {
    return '?order_by=' + orderBy +
            '&order=' + order +
            '&per_page=' + perPage +
            '&min_votes=' + minVotes +
            '&genres=' + genreId
}

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

function favoriteFromPerson(personContent) {

    var id = personContent.personId
    var title = personContent.personName
    var icon = personContent.profileImage

    return {'id': id,
            'title': title,
            'icon': icon,
            'type': PERSON,
            'url': personContent.url
    }
}

function favoriteFromMovie(movieContent) {
    var id = movieContent.tmdbId
    var title = movieContent.title
    var icon = movieContent.poster

    return {'id': id,
            'title': title,
            'icon': icon,
            'type': MOVIE,
            'url' : movieContent.url,
            'homepage' : movieContent.homepage,
            'imdbId' : movieContent.imdbId
    }
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
    this.name = obj.name
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
    this.image = obj.thumbImage

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
        'cover' : { 'width' : 0, 'height': 0, 'url': ''},
        'w342' : { 'width' : 0, 'height': 0, 'url': ''},
        'mid' : { 'width' : 0, 'height': 0, 'url': ''},
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
