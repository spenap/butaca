# Butaca: movie database #

## What is Butaca? ##

Butaca is a movie database application for MeeGo Harmattan, the operating
system running on the [Nokia N9][1]. You can use it to:

 * Get all details about a movies: release date, overview, cast & crew, trailer...
 * Get all details about a celebrity: birth details, biography, filmography...
 * Check whether a movie has extra content during or after the credits
 * Check showtimes -when available- for cinemas around you

## Get Butaca ##

Download Butaca at the [Nokia Store][10]

## How does it work? ##

Butaca uses different data sources to present its content. It gets the
information about movies and celebrities from [The Movie Database][2], an open
movie database where everybody can collaborate. It shows movie showtimes -when
available- using results from [Google Showtimes][3]. And it checks if a movie
has extra content after or during the credits (also known as "stinger") using
[What's After The Credits?][4], a website which provides that kind of
information for movies, games and other media.

## Bugs & Feedback ##

I -[Sim&oacute;n Pena][5]- develop Butaca on my free time. I am writing it hoping
that you enjoy it and find it useful, but there could be bugs or things you would
expect to work in a different way. If you find issues or have ideas to improve
this application, don't hesitate to create an entry in the [bug tracker][6].

## Contribute! ##

Butaca is free software, licensed under the [GPL 3.0][7] license, which means
there are several ways you can contribute to it:

 * [Fork the project][7], modify the sources, and send merge requests with patches
 * [Translate Butaca][8] to your language
 * File bugs or write feature requests in the [bug tracker][6]
 * Spread the word, and recommend it to your friends
 * Rate us on the [Nokia Store][9]

## Awards ##

Butaca is a proud member of the [Qt Ambassador Program][11]

## Known Issues ##

 * Butaca uses mainly `qsTrId` for translations. As reported in [QTBUG-17327][12],
in `Qt 4.7.1` `lupdate` won't extract engineering translations when `//%` is used.
Newer versions work fine.
 * There are a couple of `ListModels` translated manually using `Component.onCompleted`,
since as reported in [QTBUG-11403][13] and [QTBUG-16289][14], `qsTrId` cannot be
used inside `ListElement`

[1]: http://swipe.nokia.com/ "Nokia N9"
[2]: http://www.themoviedb.org/ "The open movie database"
[3]: http://google.com/movies "Google Movie Showtimes"
[4]: http://aftercredits.com/ "What's After The Credits?"
[5]: https://twitter.com/spenap "Simón Pena"
[6]: https://github.com/spenap/butaca/issues "Bug Tracker"
[7]: https://github.com/spenap/butaca "Butaca on GitHub"
[8]: http://www.gnu.org/licenses/gpl.html "GPL License"
[9]: https://www.transifex.net/projects/p/butaca/ "Butaca: cinema information localization"
[10]: http://store.nokia.com/content/195876 "Butaca at the Nokia Store"
[11]: http://qt.nokia.com/qt-in-use/ambassadors/project?id=a0F20000006N9pVEAS "Butaca"
[12]: https://bugreports.qt-project.org/browse/QTBUG-17327
[13]: https://bugreports.qt-project.org/browse/QTBUG-11403
[14]: https://bugreports.qt-project.org/browse/QTBUG-16289
