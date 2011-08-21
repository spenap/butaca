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

private slots:
    void onTheatersFetched(TheaterListModel* theaterListModel);

private:
    QDeclarativeContext *m_declarativeContext;
    ButacaHelper *m_butacaHelper;
    TheaterListModel *m_theaterListModel;
};

#endif // BUTACACONTROLLER_H
