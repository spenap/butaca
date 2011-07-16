QT+= declarative

SOURCES += main.cpp

OTHER_FILES += \
    qml/main.qml \
    qml/WelcomeView.qml \
    qml/ShowtimesView.qml \
    qml/SearchView.qml \
    qml/ScrollBar.qml \
    qml/PersonView.qml \
    qml/PersonModel.qml \
    qml/PersonDelegate.qml \
    qml/PeopleView.qml \
    qml/PeopleModel.qml \
    qml/PeopleDelegate.qml \
    qml/Loading.qml \
    qml/HomeView.qml \
    qml/GenresModel.qml \
    qml/GenresDelegate.qml \
    qml/DetailedMovieView.qml \
    qml/DetailedMovieModel.qml \
    qml/DetailedMovieDelegate.qml \
    qml/ButacaToolBar.qml \
    qml/BrowseGenresView.qml \
    qml/BasicMovieView.qml \
    qml/BasicMovieModel.qml \
    qml/BasicMovieDelegate.qml \
    qml/BaseMovieModel.qml \
    butaca.desktop \
    butaca.png \
    qml/images/scrollbar.png \
    qml/images/loading.png \
    qml/images/butaca-bg.jpg

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
