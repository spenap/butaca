#ifndef CONTROLLER_H
#define CONTROLLER_H

#include "imagesaver.h"
#include <QObject>

class QDeclarativeContext;
class TheaterShowtimesFetcher;
class TheaterListModel;
class SortFilterModel;

class Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QDeclarativeContext *context);
    ~Controller();

public slots:
    //! Shares content with the share-ui interface
    //! \param title The title of the content to be shared
    //! \param url The URL of the content to be shared
    void share(QString title, QString url);

    //! Fetches theater showtimes for the given location.
    //! tries to autoresolve it when it is empty
    //! \param location Specific location to fetch theater showtimes
    void fetchTheaters(QString location = QString());

    //! Retrieves the location currently used
    //! \return Location currently used
    QString currentLocation();

    //! Formats the given value as a currency
    //! \param value Value to be formatted
    //! \return Formatted value
    QString formatCurrency(QString value);

    void saveImage(QObject *item, const QString &remoteSource);

    void openStoreClient(const QString& url) const;

signals:
    //! Emitted when the theater showtimes have been fetched
    //! \param ok Tells whether the theater showtimes were successfully fetched
    void theatersFetched(bool ok);

private slots:
    void onTheatersFetched(int count);

private:
    QDeclarativeContext *m_declarativeContext;
    TheaterShowtimesFetcher *m_showtimesFetcher;
    TheaterListModel *m_theaterListModel;
    SortFilterModel *m_sortFilterModel;
    QString m_location;
    ImageSaver m_imageSaver;
};

#endif // CONTROLLER_H
