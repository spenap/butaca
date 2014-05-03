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

var GENRES_LIST         = 'genres_get_list'
var SEARCH              = 'search'
var MOVIE_BROWSE        = 'movie_browse'
var MOVIE_GET_INFO      = 'movie_get_info'
var PERSON_GET_INFO     = 'person_get_info'

var IMAGE_POSTER = 0
var IMAGE_PROFILE = 1
var IMAGE_BACKDROP = 2

var _wrapper = ''

/**
 * Gets the instance for the API wrapper, containing default
 * configuration, urls for methods and mappings for queries.
 *
 * @param {string} The locale to be used in the queries to TMDb
 * @return {object} The wrapper around TMDb API
 */
function instance(app_locale) {
    if (!_wrapper)
        _wrapper = new TMDb(app_locale)
    return _wrapper
}

/**
 * Creates an instance for the API wrapper, containing default
 * configuration, urls for methods and mappings for queries.
 *
 * @param {string} The locale to be used in the queries to TMDb
 */
function TMDb(app_locale) {
    this.config = new Object
    this.method = new Object
    this.query = new Object

    this.config['baseUrl'] = 'http://api.themoviedb.org'
    this.config['version'] = '3'
    this.config['lang_param'] = 'country'
    this.config['lang_value'] = app_locale ? app_locale : 'en'
    this.config['key_param'] = 'api_key'
    this.config['key_value'] = '249e1a42df9bee09fac5e92d3a51396b'
    this.config['page_param'] = 'page'
    this.config['page_value'] = 1
    this.config['includeAll_param'] = 'include_all_movies'
    this.config['includeAll_value'] = 'true'
    this.config['includeAdult_param'] = 'include_adult'
    this.config['includeAdult_value'] = 'true'
    this.config['image_baseUrl'] = 'http://image.tmdb.org/t/p'
    this.config[IMAGE_POSTER] = [ 'w92', 'w154', 'w185', 'w342', 'w500', 'original' ]
    this.config[IMAGE_PROFILE] = [ 'w45', 'w185', 'h632', 'original' ]
    this.config[IMAGE_BACKDROP] = [ 'w300', 'w780', 'w1280', 'original' ]

    this.method['search'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('search')
    this.method['movie_browse'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('genre')
    this.method['movie_get_info'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('movie')
    this.method['tv_get_info'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('tv')
    this.method['person_get_info'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('person')
    this.method['genres_get_list'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('genre') + _addField('list')
    this.method['configuration'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('configuration')

    this.query['movie_browse'] = this.query['search'] = '$..results[*]'
    this.query['genres_get_list'] = '$.genres[*]'

    this.getCommonUrl = _getCommonUrl
    this.toString = _toString
}

/**
 * Helper method to add a pair "arg=value" to
 * a query url. If a separator is given, it's used,
 * otherwise, the "&" is added.
 *
 * @param {string} The name for the argument
 * @param {string} The value for the argument
 * @param {string} The separator given. If empty, "&" is used
 * @return A string containing "&arg=value", or the given
 * separator instead of the "&"
 */
function _addArgument(param, value, separator) {
    if (!separator) separator = '&'
    var arg = separator + param + '=' + value
    return arg
}

/**
 * Helper method to add a parameter to a query url.
 *
 * @param {string} The parameter
 * @return The parameter, starting with a "/"
 */
function _addField(param) {
    var field = param ? '/' + param : ''
    return field
}

/**
 * Helper method which creates the common part of a query url: base url, api version,
 * method name
 *
 * @param {string} The method name
 * @param {object} The custom configuration. If empty, the default one is used
 * @return {string} A string combining the mentioned pieces
 */
function _getCommonUrl(method_name, config) {
    if (!config)
        config = { }
    var url = this.method[method_name]
    return url
}

/**
 * Helper method providing a string representation of the TMDb wrapper object
 *
 * @return {string} String representation of the TMDb wrapper object
 */
function _toString() {
    var str = 'Dumping keys & values for TMDb object\n'
    str += _dumpObject(this)
    return str
}

/**
 * Helper method which inspects an object and extracts keys and values
 *
 * @return {string} String representation of the inspection
 */
function _dumpObject(theObject) {
    var str = ''
    if (typeof(theObject) === typeof({})) {
        for (var i = 0; i < Object.keys(theObject).length; i ++) {
            var key = Object.keys(theObject)[i]
            str += 'key: ' + key + ' - value:' + theObject[key] + '\n'
            str += _dumpObject(theObject[key])
        }
    }
    return str
}

/**
 * Wrapper method which provides the API url for a search, and accepts
 * a custom configuration
 *
 * @param {string} the object to search for
 * @param {string} the search query
 * @param {object} The custom configuration for the search accepting the following
 * parameters: app_locale, page_value. Custom values are used when not provided.
 * @return {string} API url for searching
 */
function search(type, query, config) {
    if (!config)
        config = { }
    var wrapper = instance(config.app_locale)
    var page = config['page_value'] ?
                config['page_value'] :
                wrapper.config['page_value']
    var includeAdult = config['includeAdult_value'] ?
                config['includeAdult_value'] :
                wrapper.config['includeAdult_value']

    var url = wrapper.getCommonUrl('search', config) +
            _addField(type) +
            _addArgument(wrapper.config['key_param'], wrapper.config['key_value'], '?') +
            _addArgument(wrapper.config['lang_param'], wrapper.config['lang_value']) +
            _addArgument(wrapper.config['page_param'], page) +
            _addArgument(wrapper.config['includeAdult_param'], includeAdult) +
            _addArgument('query', encodeURI(query))
    console.debug('** SEARCH URL:', url)
    return url
}

/**
 * Wrapper method which provides the API url for browsing movies, and accepts
 * a custom configuration
 *
 * @param {string} the genre to browse
 * @param {object} The custom configuration for the search, accepting the following
 * parameters: app_locale, page_value, includeAll_value, includeAdult_value.
 * Custom values are used when not provided.
 * @return {string} API url for browsing movies
 */
function movie_browse(genre, config) {
    if (!config)
        config = { }
    var wrapper = instance(config.app_locale)
    var page = config['page_value'] ?
                config['page_value'] :
                wrapper.config['page_value']
    var includeAll = config['includeAll_value'] ?
                config['includeAll_value'] :
                wrapper.config['includeAll_value']
    var includeAdult = config['includeAdult_value'] ?
                config['includeAdult_value'] :
                wrapper.config['includeAdult_value']

    var url = wrapper.getCommonUrl('movie_browse', config) + _addField(genre) + _addField('movies') +
            _addArgument(wrapper.config['key_param'], wrapper.config['key_value'], '?') +
            _addArgument(wrapper.config['page_param'], page) +
            _addArgument(wrapper.config['lang_param'], wrapper.config['lang_value']) +
            _addArgument(wrapper.config['includeAll_param'], includeAll) +
            _addArgument(wrapper.config['includeAdult_param'], includeAdult)
    console.debug('** BROWSE URL:', url)
    return url
}

/**
 * Wrapper method which provides the API url for getting the full movie info,
 * and accepts the movie TMDB id and the custom configuration
 *
 * @param {string} The movie TMDB id to look up
 * @param {string} The comma-separated movie details to look for, leave empty for general info
 * @param {object} The custom configuration for the look up. Values typically
 * changed could be the app_locale.
 * @return {string} API url for looking up movie information
 */
function movie_info(movie_id, details, config) {
    if (!config)
        config = { }
    var wrapper = instance(config.app_locale)
    var url = ''
    if (details.indexOf(',') > -1)
        url = wrapper.getCommonUrl('movie_get_info', config) +
                _addField(movie_id) +
                _addArgument(wrapper.config['key_param'], wrapper.config['key_value'], '?') +
                _addArgument(wrapper.config['lang_param'], wrapper.config['lang_value']) +
                _addArgument('append_to_response', encodeURI(details))
    else
        url = wrapper.getCommonUrl('movie_get_info', config) +
                _addField(movie_id) + _addField(details) +
                _addArgument(wrapper.config['key_param'], wrapper.config['key_value'], '?') +
                _addArgument(wrapper.config['lang_param'], wrapper.config['lang_value'])
    console.debug('** MOVIE GET INFO URL:', url)
    return url
}

/**
 * Wrapper method which provides the API url for getting the full TV show info,
 * and accepts the movie TMDB id and the custom configuration
 *
 * @param {string} The tv show's TMDB id to look up
 * @param {string} The comma-separated TV show details to look for, leave empty for general info
 * @param {object} The custom configuration for the look up. Values typically
 * changed could be the app_locale.
 * @return {string} API url for looking up TV show information
 */
function tv_info(id, details, config) {
    if (!config)
        config = { }
    var wrapper = instance(config.app_locale)
    var url = ''
    if (details.indexOf(',') > -1)
        url = wrapper.getCommonUrl('tv_get_info', config) +
                _addField(id) +
                _addArgument(wrapper.config['key_param'], wrapper.config['key_value'], '?') +
                _addArgument(wrapper.config['lang_param'], wrapper.config['lang_value']) +
                _addArgument('append_to_response', encodeURI(details))
    else
        url = wrapper.getCommonUrl('tv_get_info', config) +
                _addField(id) + _addField(details) +
                _addArgument(wrapper.config['key_param'], wrapper.config['key_value'], '?') +
                _addArgument(wrapper.config['lang_param'], wrapper.config['lang_value'])
    console.debug('** TV GET INFO URL:', url)
    return url
}

/**
 * Wrapper method which provides the API url for getting the full person info,
 * and accepts the person TMDB id and the custom configuration
 *
 * @param {string} The person TMDB id to look up
 * @param {string} The comma-separated person details to look for, leave empty for general info
 * @param {object} The custom configuration for the look up. Values typically
 * changed could be the app_locale.
 * @return {string} API url for looking up person information
 */
function person_info(person_id, details, config) {
    if (!config)
        config = { }
    var wrapper = instance(config.app_locale)
    var url = ''
    if (details.indexOf(',') > -1)
        url = wrapper.getCommonUrl('person_get_info', config) +
                _addField(person_id) +
                _addArgument(wrapper.config['key_param'], wrapper.config['key_value'], '?') +
                _addArgument(wrapper.config['lang_param'], wrapper.config['lang_value']) +
                _addArgument('append_to_response', encodeURI(details))
    else
        url = wrapper.getCommonUrl('person_get_info', config) +
                _addField(person_id) + _addField(details) +
                _addArgument(wrapper.config['key_param'], wrapper.config['key_value'], '?') +
                _addArgument(wrapper.config['lang_param'], wrapper.config['lang_value'])
    console.debug('** PERSON GET INFO URL:', url)
    return url
}

/**
 * Wrapper method which provides the API url for listing genres, and accepts
 * a custom configuration
 *
 * @param {object} The custom configuration for the listing
 * @return {string} API url for listing genres
 */
function genres_list(config) {
    if (!config) config = { }
    var wrapper = instance(config.app_locale)
    var url = wrapper.getCommonUrl('genres_get_list', config) +
            _addArgument(wrapper.config['key_param'], wrapper.config['key_value'], '?') +
            _addArgument(wrapper.config['lang_param'], wrapper.config['lang_value'])
    console.debug('** GENRES GET LIST:', url)
    return url
}

/**
 * Wrapper method which provides the API url for the configuration,
 * and accepts a custom configuration
 *
 * @param {object} The custom configuration for the search
 * @return {string} API url for the configuration
 */
function configuration_getUrl(config) {
    if (!config)
        config = { }
    var wrapper = instance(config.app_locale)
    var url = wrapper.getCommonUrl('configuration', config) +
            _addArgument(wrapper.config['key_param'], wrapper.config['key_value'], '?')
    console.debug('** CONFIGURATION GET URL:', url)
    return url
}

/**
 * Wrapper method which saves the givne API configuration,
 * and accepts a custom configuration
 *
 * @param {object} parsed JSON response object
 * @param {object} The custom configuration for the search
 */
function configuration_set(jsonResponse, config) {
    if (!config)
        config = { }
    var wrapper = instance(config.app_locale)
    wrapper.config['image_baseUrl'] = jsonResponse.images.base_url
    wrapper.config[IMAGE_POSTER] = jsonResponse.images.poster_sizes
    wrapper.config[IMAGE_PROFILE] = jsonResponse.images.profile_sizes
    wrapper.config[IMAGE_BACKDROP] = jsonResponse.images.backdrop_sizes
    console.debug('** CONFIGURATION SET, e.g.', wrapper.config['image_baseUrl'],
                  wrapper.config[IMAGE_POSTER])
}

/**
 * Wrapper method which provides the API url for images, and accepts
 * the image type, size index, the file name and a custom configuration
 *
 * @param {integer} The type of image intented, e.g. IMAGE_POSTER
 * @param {integer} the size index as number
 * @param {string} The file name as given by the API
 * @param {object} The custom configuration for the search
 * @return {string} API url for the poster
 */
function image(type, index, imagePath, config) {
   switch (type) {
    case IMAGE_POSTER:
    case IMAGE_PROFILE:
    case IMAGE_BACKDROP:
        if (!config)
            config = { }
        var wrapper = instance(config.app_locale)
        if (index >= wrapper.config[type].length)
            index = wrapper.config[type].length - 1
        var url = wrapper.config['image_baseUrl'] +
                _addField(wrapper.config[type][index]) +
                _addField(imagePath)
        console.debug('** IMAGE URL:', url)
        return url
    default:
        return ''
    }
}

/**
 * Wrapper method which provides the XPath queries for parsing XML results for a
 * given method
 *
 * @param {string} The method to look up the query for
 * @return {string} XPath queries for parsing method results
 */
function query_path(method) {
    switch (method) {
    case GENRES_LIST:
    case SEARCH:
    case MOVIE_BROWSE:
        return instance().query[method]
    case MOVIE_GET_INFO:
    case PERSON_GET_INFO:
    default:
        console.debug('** QUERY PATH NOT FOUND', method)
        return ''
    }
}
