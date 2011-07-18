QT+= declarative

SOURCES += src/main.cpp \
    src/butacahelper.cpp

HEADERS += \
    src/butacahelper.h

OTHER_FILES += \
    qml/main.qml \
    qml/WelcomeView.qml \
    qml/ShowtimesView.qml \
    qml/SearchView.qml \
    qml/PersonView.qml \
    qml/PersonModel.qml \
    qml/PersonDelegate.qml \
    qml/PeopleView.qml \
    qml/PeopleModel.qml \
    qml/PeopleDelegate.qml \
    qml/GenresModel.qml \
    qml/SingleMovieView.qml \
    qml/SingleMovieModel.qml \
    qml/SingleMovieDelegate.qml \
    qml/ButacaToolBar.qml \
    qml/BrowseGenresView.qml \
    qml/MultipleMoviesView.qml \
    qml/MultipleMoviesModel.qml \
    qml/MultipleMoviesDelegate.qml \
    butaca.desktop \
    butaca.png \
    qml/images/butaca-bg.jpg \
    qml/butacautils.js \
    qml/images/movie-placeholder.svg \
    qml/images/person-placeholder.svg

RESOURCES += \
    res.qrc

# enable booster
CONFIG += qdeclarative-boostable
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
