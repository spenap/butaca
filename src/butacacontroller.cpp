#include "butacacontroller.h"
#include "butacahelper.h"
#include "theaterlistmodel.h"

#include <QDeclarativeContext>

ButacaController::ButacaController(QDeclarativeContext *context) :
    QObject(),
    m_declarativeContext(context),
    m_butacaHelper(new ButacaHelper),
    m_theaterListModel(0)
{
    m_declarativeContext->setContextProperty("helper", m_butacaHelper);

    connect(m_butacaHelper, SIGNAL(theatersFetched(TheaterListModel*)),
            this, SLOT(onTheatersFetched(TheaterListModel*)));

    m_butacaHelper->fetchTheaters();
}

ButacaController::~ButacaController()
{
    delete m_butacaHelper;
    delete m_theaterListModel;
}

void ButacaController::onTheatersFetched(TheaterListModel* theaterListModel)
{
    m_theaterListModel = theaterListModel;
    m_declarativeContext->setContextProperty("theaterModel", m_theaterListModel);
}
