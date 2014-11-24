#TEMPLATE = app

contains(QT_VERSION, ^5\\..\\..*) {
    QT += quick qml network
} else {
    QT += declarative webkit network
}

DEPENDPATH += .
INCLUDEPATH += .

# booster flags
QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
QMAKE_LFLAGS += -pie -rdynamic

PACKAGEVERSION = $$system(head -n 1 ../qtc_packaging/debian_harmattan/changelog | grep -o [0-9].[0-9].[0-9])
DEFINES += "PACKAGEVERSION=\\\"$$PACKAGEVERSION\\\""

SOURCES += main.cpp \
    theaterlistmodel.cpp \
    movie.cpp \
    sortfiltermodel.cpp \
    customnetworkaccessmanagerfactory.cpp \
    controller.cpp \
    movielistmodel.cpp \
    cinema.cpp

HEADERS += \
    theaterlistmodel.h \
    movie.h \
    sortfiltermodel.h \
    customnetworkaccessmanagerfactory.h \
    controller.h \
    movielistmodel.h \
    cinema.h

contains(MEEGO_EDITION,harmattan) {
    message("Harmattan build")

    SOURCES += imagesaver.cpp \
               theatershowtimesfetcher.cpp

    HEADERS += imagesaver.h \
               theatershowtimesfetcher.h

    TARGET = "butaca"

    # although the app doesn't use meegotouch by itself
    # linking against it removes several style warnings
    CONFIG += meegotouch

    # enable booster
    CONFIG += qt-boostable qdeclarative-boostable

    # # Use share-ui interface
    CONFIG += shareuiinterface-maemo-meegotouch mdatauri

    !simulator {
        LIBS += -lmdeclarativecache
        DEFINES += BUILD_FOR_HARMATTAN
    }

    OTHER_FILES += \
        qml/main.qml \
        qml/WelcomeView.qml \
        qml/SearchView.qml \
        qml/PersonView.qml \
        qml/GenresView.qml \
        qml/ButacaToolBar.qml \
        qml/MultipleMoviesView.qml \
        qml/MultipleMoviesDelegate.qml \
        qml/Header.qml \
        qml/NoContentItem.qml \
        qml/CastView.qml \
        qml/FilmographyView.qml \
        qml/ListSectionDelegate.qml \
        qml/TheatersView.qml \
        qml/SettingsView.qml \
        qml/AboutView.qml \
        qml/FavoriteDelegate.qml \
        qml/MovieView.qml \
        qml/MyRatingIndicator.qml \
        qml/MyMoreIndicator.qml \
        qml/MyListDelegate.qml \
        qml/MyEntryHeader.qml \
        qml/MyModelPreviewer.qml \
        qml/storage.js \
        qml/butacautils.js \
        qml/constants.js \
        resources/movie-placeholder.svg \
        resources/person-placeholder.svg \
        resources/butaca.svg \
        resources/tmdb-logo.png \
        resources/indicator-rating-inverted-star.svg \
        qml/MediaGalleryView.qml \
        qml/ZoomableImage.qml \
        qml/MyGalleryPreviewer.qml \
        qml/MyModelFlowPreviewer.qml \
        qml/MyTextExpander.qml \
        qml/moviedbwrapper.js \
        qml/ShowtimesView.qml \
        qml/FavoritesView.qml \
        qml/ListsView.qml \
        qml/JSONListModel.qml \
        qml/jsonpath.js \
        qml/TvView.qml

    RESOURCES += \
        res.qrc

    unix {
        #VARIABLES
        isEmpty(PREFIX) {
            PREFIX = /opt/$${TARGET}
        }
        BINDIR = $$PREFIX/bin
        DATADIR =$$PREFIX/share

        DEFINES += DATADIR=\\\"$$DATADIR\\\" PKGDATADIR=\\\"$$PKGDATADIR\\\"
    }
}

exists("/usr/include/sailfishapp/sailfishapp.h"): {
    message("Sailfish build")
    TARGET = harbour-butaca

    DEFINES += BUILD_FOR_SAILFISH

    CONFIG += link_pkgconfig
    PKGCONFIG += sailfishapp
    INCLUDEPATH += /usr/include/sailfishapp

    OTHER_FILES += qml/sailfish/*.qml \
                   qml/sailfish/*.js \
                   harbour-butaca.desktop \
                   ../data/harbour-butaca.png

    DEFINES -= PACKAGEVERSION
    DEFINES += PACKAGEVERSION=\\\"$$VERSION\\\"

    RESOURCES += \
        sailfish_res.qrc

    isEmpty(PREFIX) {
        PREFIX = /usr
    }
    BINDIR = $$PREFIX/bin
    DATADIR =$$PREFIX/share

    DEFINES += DATADIR=\\\"$$DATADIR\\\" PKGDATADIR=\\\"$$PKGDATADIR\\\"
}

include(deployment.pri)
qtcAddDeployment()


## Translations

CODECFORTR = UTF-8
TRANSLATIONS += \
    l10n/butaca.es.ts \
    l10n/butaca.en.ts \
    l10n/butaca.de.ts \
    l10n/butaca.fi.ts \
    l10n/butaca.fr_FR.ts \
    l10n/butaca.ro.ts \
    l10n/butaca.tr.ts \
    l10n/butaca.pt_PT.ts \
    l10n/butaca.pt_BR.ts \
    l10n/butaca.cs.ts \
    l10n/butaca.it_IT.ts \
    l10n/butaca.vi.ts \
    l10n/butaca.en_GB.ts \
    l10n/butaca.nl.ts

# Rule for regenerating .qm files for translations (missing in qmake
# default ruleset, ugh!)
#
updateqm.input = TRANSLATIONS
updateqm.output = ${QMAKE_FILE_PATH}/${QMAKE_FILE_BASE}.qm
updateqm.commands = lrelease ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
updateqm.CONFIG += no_link
QMAKE_EXTRA_COMPILERS += updateqm
PRE_TARGETDEPS += compiler_updateqm_make_all
