.pragma library

var STINGERS_NONE           = 0
var STINGERS_DURING_CREDITS = 1
var STINGERS_AFTER_CREDITS  = 2

function AfterCreditsMovie(title, url, content) {
    this.year = title.match(/\(\d\d\d\d/gi)[0].slice(1)
    this.title = title.replace(/\(\d\d\d\d\).*/gi, '')
    this.url = url
    this.content = content
    this.dataConfirmed = false
    this.hasStingers = false
    this.stingersType = STINGERS_NONE
    var regExp=/http:\/\/www\.imdb\.com\/title\/tt\d*/gi
    this.imdbId = content.match(regExp)
    console.debug(this.imdbId)

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
    this.subtitle = getSubtitle(this.stingersType, this.year)
}

function getSubtitle(stingerType, year) {
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
