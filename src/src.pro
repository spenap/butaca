TEMPLATE = app
QT += declarative webkit network
TARGET = "butaca"
DEPENDPATH += .
INCLUDEPATH += .

# although the app doesn't use meegotouch by itself
# linking against it removes several style warnings
CONFIG += meegotouch

# enable booster
CONFIG += qt-boostable qdeclarative-boostable

# booster flags
QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
QMAKE_LFLAGS += -pie -rdynamic

# # Use share-ui interface
CONFIG += shareuiinterface-maemo-meegotouch mdatauri

!simulator {
    LIBS += -lmdeclarativecache
}

SOURCES += main.cpp \
    theaterlistmodel.cpp \
    movie.cpp \
    theatershowtimesfetcher.cpp \
    sortfiltermodel.cpp \
    customnetworkaccessmanagerfactory.cpp \
    controller.cpp

HEADERS += \
    theaterlistmodel.h \
    movie.h \
    theatershowtimesfetcher.h \
    sortfiltermodel.h \
    customnetworkaccessmanagerfactory.h \
    controller.h

OTHER_FILES += \
    qml/main.qml \
    qml/WelcomeView.qml \
    qml/SearchView.qml \
    qml/PersonModel.qml \
    qml/PersonDelegate.qml \
    qml/PeopleModel.qml \
    qml/GenresView.qml \
    qml/GenresModel.qml \
    qml/ButacaToolBar.qml \
    qml/MultipleMoviesView.qml \
    qml/MultipleMoviesModel.qml \
    qml/MultipleMoviesDelegate.qml \
    qml/Header.qml \
    qml/NoContentItem.qml \
    qml/CastModel.qml \
    qml/CastView.qml \
    qml/FilmographyModel.qml \
    qml/FilmographyView.qml \
    qml/DetailedView.qml \
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
    qml/storage.js \
    qml/butacautils.js \
    qml/constants.js \
    qml/workerscript.js \
    resources/movie-placeholder.svg \
    resources/person-placeholder.svg \
    resources/butaca.svg \
    resources/tmdb-logo.png \
    resources/indicator-rating-inverted-star.svg

RESOURCES += \
    res.qrc

CODECFORTR = UTF-8
TRANSLATIONS += \
    l10n/butaca.es.ts \
    l10n/butaca.en.ts \
    l10n/butaca.de.ts \
    l10n/butaca.fi.ts \
    l10n/butaca.fr_FR.ts \
    l10n/butaca.ro.ts \
    l10n/butaca.tr.ts \
    l10n/butaca.pt.ts

unix {
    #VARIABLES
    isEmpty(PREFIX) {
        PREFIX = /usr
    }
    BINDIR = $$PREFIX/bin
    DATADIR =$$PREFIX/share

    DEFINES += DATADIR=\\\"$$DATADIR\\\" PKGDATADIR=\\\"$$PKGDATADIR\\\"

    #MAKE INSTALL

    INSTALLS += target desktop icon64 splash

    target.path =$$BINDIR

    desktop.path = $$DATADIR/applications
    desktop.files += $${TARGET}.desktop

    icon64.path = $$DATADIR/icons/hicolor/64x64/apps
    icon64.files += ../data/$${TARGET}.png

    splash.path = $$DATADIR/$${TARGET}/
    splash.files += ../data/butaca-splash.jpg
}

# Rule for regenerating .qm files for translations (missing in qmake
# default ruleset, ugh!)
#
updateqm.input = TRANSLATIONS
updateqm.output = ${QMAKE_FILE_PATH}/${QMAKE_FILE_BASE}.qm
updateqm.commands = lrelease ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
updateqm.CONFIG += no_link
QMAKE_EXTRA_COMPILERS += updateqm
PRE_TARGETDEPS += compiler_updateqm_make_all
