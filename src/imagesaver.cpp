#include "imagesaver.h"
#include <QGraphicsObject>
#include <QPainter>
#include <QStyleOptionGraphicsItem>

void ImageSaver::save(QObject *qmlImage, const QString &fileName)
{
    QGraphicsObject *graphicsObject = qobject_cast<QGraphicsObject*>(qmlImage);

    if (graphicsObject) {

        QImage image(graphicsObject->boundingRect().size().toSize(), QImage::Format_RGB32);
        image.fill(QColor(255, 255, 255).rgb());
        QPainter painter(&image);
        QStyleOptionGraphicsItem styleOption;
        graphicsObject->paint(&painter, &styleOption);

        image.save(fileName);
    }
}
