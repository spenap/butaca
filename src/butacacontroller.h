#ifndef BUTACACONTROLLER_H
#define BUTACACONTROLLER_H

#include <QObject>

class QDeclarativeContext;
class TheaterShowtimesFetcher;
class TheaterListModel;

class ButacaController : public QObject
{
    Q_OBJECT
public:
    explicit ButacaController(QDeclarativeContext *context);
    ~ButacaController();

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

signals:
    //! Emitted when the theater showtimes have been fetched
    //! \param ok Tells whether the theater showtimes were successfully fetched
    void theatersFetched(bool ok);

private slots:
    void onTheatersFetched(TheaterListModel* theaterListModel);

private:
    QDeclarativeContext *m_declarativeContext;
    TheaterShowtimesFetcher *m_showtimesFetcher;
    TheaterListModel *m_theaterListModel;
    QString m_location;
};

#endif // BUTACACONTROLLER_H
