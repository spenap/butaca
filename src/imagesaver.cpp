/**************************************************************************
 *   Butaca
 *   Copyright (C) 2011 - 2012 Simon Pena <spena@igalia.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 **************************************************************************/

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
