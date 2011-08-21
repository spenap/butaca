QT+= declarative webkit

SOURCES += src/main.cpp \
    src/butacahelper.cpp \
    src/theaterlistmodel.cpp \
    src/butacacontroller.cpp \
    src/movie.cpp

HEADERS += \
    src/butacahelper.h \
    src/theaterlistmodel.h \
    src/butacacontroller.h \
    src/movie.h

OTHER_FILES += \
    qml/main.qml \
    qml/WelcomeView.qml \
    qml/SearchView.qml \
    qml/PersonModel.qml \
    qml/PersonDelegate.qml \
    qml/PeopleModel.qml \
    qml/PeopleDelegate.qml \
    qml/GenresModel.qml \
    qml/SingleMovieModel.qml \
    qml/SingleMovieDelegate.qml \
    qml/ButacaToolBar.qml \
    qml/BrowseGenresView.qml \
    qml/MultipleMoviesView.qml \
    qml/MultipleMoviesModel.qml \
    qml/MultipleMoviesDelegate.qml \
    butaca.desktop \
    butaca.png \
    TODO \
    qml/butacautils.js \
    qml/images/movie-placeholder.svg \
    qml/images/person-placeholder.svg \
    qml/CustomMoreIndicator.qml \
    qml/ButacaHeader.qml \
    qml/NoContentItem.qml \
    qml/CastModel.qml \
    qml/CastView.qml \
    qml/FilmographyModel.qml \
    qml/FilmographyView.qml \
    qml/storage.js \
    qml/DetailedView.qml \
    qml/ListSectionDelegate.qml \
    qml/TheatersView.qml \
    qml/SettingsView.qml

RESOURCES += \
    res.qrc

# enable booster
CONFIG += qt-boostable qdeclarative-boostable \
          shareuiinterface-maemo-meegotouch \
          mdatauri
QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden
QMAKE_LFLAGS += -pie -rdynamic

LIBS += -lmdeclarativecache

butacascript.files = butaca
butacascript.path = /usr/bin/

desktop.files = butaca.desktop
desktop.path = /usr/share/applications/

icon.files = butaca.png
icon.path  = /usr/share/icons/hicolor/64x64/apps/

INSTALLS += butacascript desktop icon
