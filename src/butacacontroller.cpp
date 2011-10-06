#include "butacacontroller.h"
#include "theatershowtimesfetcher.h"
#include "theaterlistmodel.h"
#include "sortfiltermodel.h"

#include <QDeclarativeContext>
#include <maemo-meegotouch-interfaces/shareuiinterface.h>
#include <MDataUri>

ButacaController::ButacaController(QDeclarativeContext *context) :
    QObject(),
    m_declarativeContext(context),
    m_showtimesFetcher(0),
    m_theaterListModel(new TheaterListModel),
    m_sortFilterModel(new SortFilterModel)
{
    m_sortFilterModel->setDynamicSortFilter(true);
    m_sortFilterModel->setSourceModel(m_theaterListModel);
    connect(m_theaterListModel, SIGNAL(countChanged()),
            m_sortFilterModel, SIGNAL(countChanged()), Qt::UniqueConnection);

    m_declarativeContext->setContextProperty("controller", this);
    m_declarativeContext->setContextProperty("theaterModel", m_sortFilterModel);

    m_showtimesFetcher = new TheaterShowtimesFetcher(m_theaterListModel);
    connect(m_showtimesFetcher, SIGNAL(theatersFetched(int)),
            this, SLOT(onTheatersFetched(int)), Qt::UniqueConnection);
}

ButacaController::~ButacaController()
{
    delete m_showtimesFetcher;
    delete m_sortFilterModel;
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
    dataUri.setAttribute("description", tr("Shared with #Butaca"));

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

void ButacaController::onTheatersFetched(int count)
{
    emit theatersFetched(count > 0);
}

QString ButacaController::formatCurrency(QString value)
{
    double doubleValue = value.toDouble();
    return QString("$%L1").arg(doubleValue, 0, 'f', 0);
}
