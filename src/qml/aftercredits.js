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

var STINGERS_NONE           = 0
var STINGERS_DURING_CREDITS = 1
var STINGERS_AFTER_CREDITS  = 2

function movie_extras(movie_name) {
    var url = 'http://aftercredits.com/api/get_search_results?search=' + encodeURI(movie_name)
    console.debug('** MOVIE EXTRAS:', url)
    return url
}

function ACMovie(title, url, content) {
    this.year = title.match(/\(\d\d\d\d/gi)[0].slice(1)
    this.title = title.replace(/\(\d\d\d\d\).*/gi, '')
    this.url = url
    this.content = content
    this.dataConfirmed = false
    this.hasStingers = false
    this.stingersType = STINGERS_NONE
    var regExp=/http:\/\/www\.imdb\.com\/title\/tt\d*/gi
    this.imdbId = content.match(regExp)

    this.addCategory = _addCategory
    this.toString = _toString
}

function _addCategory(category) {
    if (category.slug === 'confirmed') {
        this.dataConfirmed = true
    }
    if (category.slug === 'unconfirmed') {
        this.dataConfirmed = false
    }
    if (category.slug === 'non-stingers') {
        this.hasStingers = false
        this.stingersType = STINGERS_NONE
    }
    if (category.slug === 'after-credits') {
        this.hasStingers = true
        this.stingersType |= STINGERS_AFTER_CREDITS
    }
    if (category.slug === 'during-credits') {
        this.hasStingers = true
        this.stingersType |= STINGERS_DURING_CREDITS
    }
    if (category.slug === 'both-during-after-credits') {
        this.hasStingers = true
        this.stingersType |= (STINGERS_AFTER_CREDITS | STINGERS_DURING_CREDITS)
    }
    this.subtitle = _getSubtitle(this.stingersType, this.year)
}

function _getSubtitle(stingerType, year) {
    var subtitle = ''
    if (stingerType === STINGERS_NONE) {
        subtitle  += 'no extra content'
    } else {
        if (stingerType & STINGERS_DURING_CREDITS) {
            subtitle += 'during the credits'
        }
        if (stingerType & STINGERS_AFTER_CREDITS) {
            if (stingerType & STINGERS_DURING_CREDITS) {
                subtitle += ' & '
            }
            subtitle += 'after the credits'
        }
    }
    return subtitle
}

function _toString() {
    var formattedMovie = 'title: ' + this.title
    formattedMovie += ', url: ' + this.url
    if (this.hasStingers) {
        formattedMovie += ', has stingers '
        if (this.stingersType & STINGERS_DURING_CREDITS) {
            formattedMovie += ' during credits'
        }
        if (this.stingersType & STINGERS_AFTER_CREDITS) {
            formattedMovie += ' after credits'
        }
    } else {
        formattedMovie += ', doesn\'t have stingers'
    }
    formattedMovie += this.dataConfirmed ? ' (data confirmed)' : '(data unconfirmed)'
    return formattedMovie
}

function parseACResponse(ac_response, imdb_id_candidate) {
    if (ac_response.posts) {
        for (var i = 0; i < ac_response.posts.length; i ++) {
            var post = ac_response.posts[i]
            if (post.url !== 'http://aftercredits.com/privacy-policy/') {
                var movie = new ACMovie(post.title, post.url, post.content)
                if ((movie.imdbId + '').indexOf(imdb_id_candidate) >= 0) {
                    if (post.categories) {
                        for (var j = 0; j < post.categories.length; j ++) {
                            var category = post.categories[j]
                            movie.addCategory(category)
                        }
                    }
                    return movie
                }
            }
        }
    }
    return undefined
}
