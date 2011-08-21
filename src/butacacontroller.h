#ifndef BUTACACONTROLLER_H
#define BUTACACONTROLLER_H

#include <QObject>

class QDeclarativeContext;
class ButacaHelper;
class TheaterListModel;

class ButacaController : public QObject
{
    Q_OBJECT
public:
    explicit ButacaController(QDeclarativeContext *context);
    ~ButacaController();

public slots:
    void fetchTheaters(QString location = QString());
    const QString &currentLocation() const;

private slots:
    void onTheatersFetched(TheaterListModel* theaterListModel);

private:
    QDeclarativeContext *m_declarativeContext;
    ButacaHelper *m_butacaHelper;
    TheaterListModel *m_theaterListModel;
    QString m_location;
};

#endif // BUTACACONTROLLER_H
