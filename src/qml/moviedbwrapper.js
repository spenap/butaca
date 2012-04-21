.pragma library

var GENRES_LIST         = 'genres_get_list'
var MOVIE_SEARCH        = 'movie_search'
var MOVIE_BROWSE        = 'movie_browse'
var MOVIE_IMDB_LOOKUP   = 'movie_imdb_lookup'
var MOVIE_GET_INFO      = 'movie_get_info'
var PERSON_SEARCH       = 'person_search'
var PERSON_GET_INFO     = 'person_get_info'

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
    this.config['version'] = '2.1'
    this.config['lang'] = app_locale ? app_locale : 'en'
    this.config['key'] = '249e1a42df9bee09fac5e92d3a51396b'
    this.config['format'] = 'xml'
    this.config['browse_orderBy_param'] = 'order_by'
    this.config['browse_orderBy_value'] = ''
    this.config['browse_order_param'] = 'order'
    this.config['browse_order_value'] = ''
    this.config['browse_page_param'] = 'page'
    this.config['browse_page_value'] = 1
    this.config['browse_count_param'] = 'per_page'
    this.config['browse_count_value'] = 20
    this.config['browse_minvotes_param'] = 'min_votes'
    this.config['browse_minvotes_value'] = 5
    this.config['browse_genres_param'] = 'genres'
    this.config['browse_genres_value'] = ''

    this.method['movie_search'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('Movie.search')
    this.method['movie_browse'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('Movie.browse')
    this.method['movie_get_info'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('Movie.getInfo')
    this.method['movie_imdb_lookup'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('Movie.imdbLookup')
    this.method['person_search'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('Person.search')
    this.method['person_get_info'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('Person.getInfo')
    this.method['genres_get_list'] = this.config['baseUrl'] +
         _addField(this.config['version']) + _addField('Genres.getList')

    this.query['movie_browse'] = this.query['movie_search'] = '/OpenSearchDescription/movies/movie'
    this.query['person_search'] = '/OpenSearchDescription/people/person'
    this.query['genres_get_list'] = '/OpenSearchDescription/genres/genre'

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
    var field = '/' + param
    return field
}

/**
 * Helper method which creates the common part of a query url: base url, api version,
 * method name, language, format and api key
 *
 * @param {string} The method name
 * @param {object} The custom configuration. If empty, the default one is used
 * @return {string} A string combining the mentioned pieces
 */
function _getCommonUrl(method_name, config) {
    if (!config)
        config = { }
    var url = this.method[method_name] +
            _addField(config['lang'] ? config['lang'] : this.config['lang']) +
            _addField(config['format'] ? config['format'] : this.config['format']) +
            _addField(this.config['key'])
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
 * Wrapper method which provides the API url for a movie search, and accepts
 * a movie name and a custom configuration
 *
 * @param {string} The movie name to look for
 * @param {object} The custom configuration for the search
 * @return {string} API url for searching a movie
 */
function movie_search(movie_name, config) {
    if (!config) config = { }
    var url = instance(config.app_locale).getCommonUrl('movie_search', config) +
            _addField(movie_name)
    console.debug('** SEARCH URL:', url)
    return url
}

/**
 * Wrapper method which provides the API url for browsing movies, and accepts
 * a custom configuration
 *
 * @param {object} The custom configuration for the search, accepting the following
 * parameters: browse_orderBy_value, browse_order_value, browse_page_value, browse_count_value,
 * browse_genres_value. Custom values are used when not provided.
 * @return {string} API url for browsing movies
 */
function movie_browse(browse_config) {
    if (!browse_config)
        browse_config = { }
    var wrapper = instance(browse_config.app_locale)
    var orderBy = browse_config['browse_orderBy_value'] ?
                browse_config['browse_orderBy_value'] :
                wrapper.config['browse_orderBy_value']
    var order = browse_config['browse_order_value'] ?
                browse_config['browse_order_value'] :
                wrapper.config['browse_order_value']
    var page = browse_config['browse_page_value'] ?
                browse_config['browse_page_value'] :
                wrapper.config['browse_page_value']
    var count = browse_config['browse_count_value'] ?
                browse_config['browse_count_value'] :
                wrapper.config['browse_count_value']
    var minVotes = browse_config['browse_minvotes_value'] ?
                browse_config['browse_minvotes_value'] :
                wrapper.config['browse_minvotes_value']
    var genres = browse_config['browse_genres_value'] ?
                browse_config['browse_genres_value'] :
                wrapper.config['browse_genres_value']

    var url = wrapper.getCommonUrl('movie_browse', browse_config) +
            _addArgument(wrapper.config['browse_orderBy_param'], orderBy, '?') +
            _addArgument(wrapper.config['browse_order_param'], order) +
            _addArgument(wrapper.config['browse_page_param'], page) +
            _addArgument(wrapper.config['browse_count_param'], count) +
            _addArgument(wrapper.config['browse_minvotes_param'], minVotes) +
            _addArgument(wrapper.config['browse_genres_param'], genres)
    console.debug('** BROWSE URL:', url)
    return url
}

/**
 * Wrapper method which provides the API url for getting the full movie info,
 * and accepts the movie TMDB id and the custom configuration
 *
 * @param {string} The movie TMDB id to look up
 * @param {object} The custom configuration for the look up. Values typically
 * changed could be the app_locale and the return format.
 * @return {string} API url for looking up movie information
 */
function movie_info(movie_id, config) {
    if (!config)
        config = { format: 'json' }
    var url = instance(config.app_locale).getCommonUrl('movie_get_info', config) +
            _addField(movie_id)
    console.debug('** MOVIE GET INFO URL:', url)
    return url
}

/**
 * Wrapper method which provides the API url for getting the full movie info,
 * and accepts the movie IMDB id and the custom configuration
 *
 * @param {string} The movie IMDB id to look up
 * @param {object} The custom configuration for the look up. Values typically
 * changed could be the app_locale and the return format.
 * @return {string} API url for looking up movie information
 */
function movie_imdb_lookup(imdb_id, config) {
    if (!config)
        config = { format: 'json' }
    var url = instance(config.app_locale).getCommonUrl('movie_imdb_lookup', config) +
            _addField(imdb_id)
    console.debug('** IMDB LOOKUP URL:', url)
    return url
}

/**
 * Wrapper method which provides the API url for searching people, and accepts
 * the person name and a custom configuration
 *
 * @param {string} The person name to search
 * @param {object} The custom configuration for the search
 * @return {string} API url for searching people
 */
function person_search(person_name, config) {
    if (!config) config = { }
    var url = instance(config.app_locale).getCommonUrl('person_search', config) +
            _addField(person_name)
    console.debug('** PERSON SEARCH URL:', url)
    return url
}

/**
 * Wrapper method which provides the API url for getting the full person info,
 * and accepts the person TMDB id and the custom configuration
 *
 * @param {string} The person TMDB id to look up
 * @param {object} The custom configuration for the look up. Values typically
 * changed could be the app_locale and the return format.
 * @return {string} API url for looking up person information
 */
function person_info(person_id, config) {
    if (!config) config = { format: 'json' }
    var url = instance(config.app_locale).getCommonUrl('person_get_info', config) +
            _addField(person_id)
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
    var url = instance(config.app_locale).getCommonUrl('genres_get_list', config)
    console.debug('** GENRES GET LIST:', url)
    return url
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
    case MOVIE_SEARCH:
    case MOVIE_BROWSE:
    case PERSON_SEARCH:
        return instance().query[method]
    case MOVIE_IMDB_LOOKUP:
    case MOVIE_GET_INFO:
    case PERSON_GET_INFO:
    default:
        console.debug('** QUERY PATH NOT FOUND', method)
        return ''
    }
}
