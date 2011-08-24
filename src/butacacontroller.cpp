#include "butacacontroller.h"
#include "theatershowtimesfetcher.h"
#include "theaterlistmodel.h"

#include <QDeclarativeContext>
#include <maemo-meegotouch-interfaces/shareuiinterface.h>
#include <MDataUri>

ButacaController::ButacaController(QDeclarativeContext *context) :
    QObject(),
    m_declarativeContext(context),
    m_showtimesFetcher(new TheaterShowtimesFetcher),
    m_theaterListModel(0)
{
    m_declarativeContext->setContextProperty("controller", this);

    connect(m_showtimesFetcher, SIGNAL(theatersFetched(TheaterListModel*)),
            this, SLOT(onTheatersFetched(TheaterListModel*)));
}

ButacaController::~ButacaController()
{
    delete m_showtimesFetcher;
    delete m_theaterListModel;
}

void ButacaController::share(QString title, QString url)
{
    // See https://meego.gitorious.org/meego-sharing-framework/share-ui/blobs/master/examples/link-share/page.cpp
    // and http://forum.meego.com/showthread.php?t=3768
    MDataUri dataUri;
    dataUri.setMimeType("text/x-url");
    dataUri.setTextData(url);
    dataUri.setAttribute("title", title);
    dataUri.setAttribute("description", "Shared with #Butaca");

    QStringList items;
    items << dataUri.toString();
    ShareUiInterface shareIf("com.nokia.ShareUi");
    if (shareIf.isValid()) {
        shareIf.share(items);
    } else {
        qCritical() << "Invalid interface";
    }
}

void ButacaController::fetchTheaters(QString location)
{
    m_location = location;
    m_showtimesFetcher->fetchTheaters(m_location);
}

QString ButacaController::currentLocation()
{
    return m_location;
}

void ButacaController::onTheatersFetched(TheaterListModel* theaterListModel)
{
    if (m_theaterListModel) {
        delete m_theaterListModel;
        m_theaterListModel = 0;
    }

    if (theaterListModel) {
        m_theaterListModel = theaterListModel;
        m_declarativeContext->setContextProperty("theaterModel", m_theaterListModel);

        emit theatersFetched(true);
    } else {
        emit theatersFetched(false);
    }
}

QString ButacaController::formatCurrency(QString value)
{
    double doubleValue = value.toDouble();
    return QString("$%L1").arg(doubleValue, 0, 'f', 0);
}
