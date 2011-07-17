#include "butacahelper.h"

#include <QtGui/QApplication>
#include <QtDeclarative>
#include <QDeclarativeContext>
#include <applauncherd/mdeclarativecache.h>

static QApplication* app;
static QDeclarativeView* view;

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    app = MDeclarativeCache::qApplication(argc, argv);
    view = MDeclarativeCache::qDeclarativeView();
    QDeclarativeContext* context = view->rootContext();
    ButacaHelper* butacaHelper = new ButacaHelper();

    context->setContextProperty("helper", butacaHelper);

    view->setSource(QUrl("qrc:/qml/main.qml"));
    view->showFullScreen();

    int result = app->exec();

    delete context;
    delete butacaHelper;

    return result;
}
