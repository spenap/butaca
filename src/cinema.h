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

#ifndef CINEMA_H
#define CINEMA_H

#include "movie.h"

#include <QString>
#include <QList>

class MovieListModel;

//! \class Cinema
//! \brief Class representing a cinema where movies are playing
//!
//! The class contains the cinema name and info (details such as address or
//! phone number), as well as showtimes for movies playing there.
class Cinema
{
public:
    //! Constructor: creates a cinema with the given info
    //! \param name The name for this cinema
    //! \param info Extra details, such as address and or phone number
    //! \param movies The movies playing at the cinema
    Cinema(const QString& name, const QString& info, QList<Movie> movies = QList<Movie>());

    //! Destructor
    ~Cinema();

    //! Gets the name of this cinema
    //! \return The name of the cinema
    const QString name() const;

    //! Gets the info of this cinema
    //! \return The extra details of this cinema
    const QString info() const;

    //! Sets the name of this cinema
    //! \param name The name of the cinema
    void setName(const QString& name);

    //! Sets the info of this cinema
    //! \param info Extra details of this cinema
    void setInfo(const QString& info);

    //! Gets the showtimes model
    //! \return Showtimes model
    const MovieListModel* showtimesModel() const;

    //! Sets the movies playing at the cinema
    //! \param movies The movies playing at the cinema
    void setMovies(QList<Movie> movies);

private:
    QString m_name;
    QString m_info;
    MovieListModel* m_moviesModel;
};

#endif // CINEMA_H
