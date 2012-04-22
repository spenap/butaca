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

class Movie
{
public:
    const QString movieName() const;
    const QString movieTimes() const;
    const QString movieDescription() const;
    const QString movieId() const;
    const QString movieInfo() const;
    const QString movieImdbId() const;
    const QString theaterName() const;
    const QString theaterInfo() const;

    void setMovieName(const QString &name);
    void setMovieTimes(const QString &times);
    void setMovieDescription(const QString &description);
    void setMovieId(const QString &id);
    void setMovieInfo(const QString &info);
    void setMovieImdbId(const QString &imdbId);
    void setTheaterName(const QString &name);
    void setTheaterInfo(const QString &info);

private:
    QString m_movieName;
    QString m_movieTimes;
    QString m_movieDescription;
    QString m_movieId;
    QString m_movieInfo;
    QString m_movieImdbId;
    QString m_theaterName;
    QString m_theaterInfo;
};

#endif // MOVIE_H
