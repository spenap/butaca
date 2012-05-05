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

#ifndef MOVIE_H
#define MOVIE_H

#include <QString>

//! \class Movie
//! \brief Class representing a movie playing at a cinema
//!
//! The class contains the movie name and info (details such as genres),
//! as well as a description, showtimes, or IMDB id if available
class Movie
{
public:
    //! Gets the movie id
    //! \return The movie identifier
    const QString id() const;

    //! Gets the movie IMDB identifier
    //! \return The movie IMDB identifier
    const QString imdbId() const;

    //! Gets the movie name
    //! \return The movie name
    const QString name() const;

    //! Gets the movie showtimes
    //! \return The movie showtimes
    const QString showtimes() const;

    //! Gets the movie description
    //! \return The movie description
    const QString description() const;

    //! Gets the movie info (such as genre)
    //! \return The movie info
    const QString info() const;

    //! Sets the movie identifier
    //! \param id The movie identifier
    void setId(const QString& id);

    //! Sets the movie IMDB identifier
    //! \param imdbId The movie IMDB identifier
    void setImdbId(const QString& imdbId);

    //! Sets the movie name
    //! \param name The movie name
    void setName(const QString& name);

    //! Sets the movie showtimes
    //! \param showtimes The movie showtimes
    void setShowtimes(const QString& showtimes);

    //! Sets the movie description
    //! \param description The movie description
    void setDescription(const QString& description);

    //! Sets the movie info (such as genre)
    //! \param info The movie info
    void setInfo(const QString& info);

private:
    QString m_id;
    QString m_imdbId;
    QString m_name;
    QString m_showtimes;
    QString m_description;
    QString m_info;
};

#endif // MOVIE_H
