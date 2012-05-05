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

#include "cinema.h"
#include "movielistmodel.h"

Cinema::Cinema(const QString& name, const QString& info, QList<Movie> movies) :
    m_moviesPlaying(movies)
{
    m_name = name;
    m_info = info;
}

Cinema::~Cinema()
{
}

const QString Cinema::name() const
{
    return m_name;
}

const QString Cinema::info() const
{
    return m_info;
}

MovieListModel* Cinema::showtimesModel() const
{
    MovieListModel* model = new MovieListModel;
    model->setMovieList(m_moviesPlaying);
    return model;
}

void Cinema::setName(const QString &name)
{
    m_name = name;
}

void Cinema::setInfo(const QString &info)
{
    m_info = info;
}

void Cinema::setMovies(QList<Movie> movies)
{
    m_moviesPlaying.append(movies);
}
