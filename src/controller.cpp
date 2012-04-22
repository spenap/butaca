#include "controller.h"
#include "theatershowtimesfetcher.h"
#include "theaterlistmodel.h"
#include "sortfiltermodel.h"

#include <QDeclarativeContext>
#include <QFileInfo>
#ifndef QT_SIMULATOR
    #include <maemo-meegotouch-interfaces/shareuiinterface.h>
    #include <MDataUri>
    #include <QDBusInterface>
    #include <QDBusPendingCall>
#else
    #include <QDebug>
#endif
#include <QStringList>

static const QString LAST_UPDATE_KEY("lastUpdate");
static const QString STORE_DBUS_IFACE("com.nokia.OviStoreClient");

static const QString PICTURES_PATH("/home/user/MyDocs/Pictures/");

Controller::Controller(QDeclarativeContext *context) :
    QObject(),
    m_declarativeContext(context),
    m_showtimesFetcher(0),
    m_theaterListModel(new TheaterListModel),
    m_sortFilterModel(new SortFilterModel),
    m_imageSaver()
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

Controller::~Controller()
{
    delete m_showtimesFetcher;
    delete m_sortFilterModel;
    delete m_theaterListModel;
}

void Controller::share(QString title, QString url)
{
#ifndef QT_SIMULATOR
    // See https://meego.gitorious.org/meego-sharing-framework/share-ui/blobs/master/examples/link-share/page.cpp
    // and http://forum.meego.com/showthread.php?t=3768
    MDataUri dataUri;
    dataUri.setMimeType("text/x-url");
    dataUri.setTextData(url);
    dataUri.setAttribute("title", title);
    //: Shared with #Butaca
    dataUri.setAttribute("description", tr("btc-shared-with-butaca"));

    QStringList items;
    items << dataUri.toString();
    ShareUiInterface shareIf("com.nokia.ShareUi");
    if (shareIf.isValid()) {
        shareIf.share(items);
    } else {
        qCritical() << "Invalid interface";
    }
#else
    Q_UNUSED(title)
    Q_UNUSED(url)
#endif
}

void Controller::fetchTheaters(QString location)
{
    m_location = location;
    m_showtimesFetcher->fetchTheaters(m_location);
}

QString Controller::currentLocation()
{
    return m_location;
}

void Controller::onTheatersFetched(int count)
{
    emit theatersFetched(count > 0);
}

QString Controller::formatCurrency(QString value)
{
    double doubleValue = value.toDouble();
    return QString("$%L1").arg(doubleValue, 0, 'f', 0);
}

void Controller::saveImage(QObject *item, const QString &remoteSource)
{
    QFileInfo imageUrl(remoteSource);
    QUrl sourceUrl = QUrl::fromUserInput(PICTURES_PATH +
                                         imageUrl.fileName());
#ifdef QT_SIMULATOR
    Q_UNUSED(item)
    qDebug() << Q_FUNC_INFO << sourceUrl.toLocalFile();
#else
    m_imageSaver.save(item, sourceUrl.toLocalFile());
#endif
}

void Controller::openStoreClient(const QString& url) const
{
    // Based on
    // https://gitorious.org/n9-apps-client/n9-apps-client/blobs/master/daemon/notificationhandler.cpp#line178
#ifdef QT_SIMULATOR
    Q_UNUSED(url)
#else
    QDBusInterface dbusInterface(STORE_DBUS_IFACE,
                                 "/",
                                 STORE_DBUS_IFACE,
                                 QDBusConnection::sessionBus());

    QStringList callParams;
    callParams << url;

    dbusInterface.asyncCall("LaunchWithLink", QVariant::fromValue(callParams));
#endif
}
