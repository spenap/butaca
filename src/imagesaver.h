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

#ifndef IMAGESAVER_H
#define IMAGESAVER_H

#include <QObject>

//! \class ImageSaver
//! \brief Convenience class which allows saving a QML image to disk
//!
//! This class provides a method which takes a QML image and saves it to disk
class ImageSaver
{
public:
    //! Saves a QML image to disk
    //! \param item The QML image, as a QObject pointer
    //! \param fileName The fileName where the image is saved
    static void save(QObject* item, const QString& fileName);

};

#endif // IMAGESAVER_H
