#include <QtGui/QApplication>
#include <QtDeclarative>
#include <applauncherd/mdeclarativecache.h>

static QApplication* app;
static QDeclarativeView* view;

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    app = MDeclarativeCache::qApplication(argc, argv);
    view = MDeclarativeCache::qDeclarativeView();
    view->setSource(QUrl("qrc:/qml/main.qml"));
    view->showFullScreen();

    int result = app->exec();

    return result;
}
