#include "butacahelper.h"

#include <QDesktopServices>
#include <QUrl>

ButacaHelper::ButacaHelper(QObject *parent) :
    QObject(parent)
{

}

void ButacaHelper::openVideo(QString url)
{
    QUrl videoUrl(url);
    QDesktopServices::openUrl(videoUrl);
}
