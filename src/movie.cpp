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

#include "movie.h"

const QString Movie::name() const
{
    return m_name;
}

const QString Movie::showtimes() const
{
    return m_showtimes;
}

const QString Movie::description() const
{
    return m_description;
}

const QString Movie::imdbId() const
{
    return m_imdbId;
}

const QString Movie::id() const
{
    return m_id;
}

const QString Movie::info() const
{
    return m_info;
}

void Movie::setName(const QString &name)
{
    m_name = name;
}

void Movie::setShowtimes(const QString &times)
{
    m_showtimes = times;
}

void Movie::setImdbId(const QString &imdbId)
{
    m_imdbId = imdbId;
}

void Movie::setDescription(const QString &description)
{
    m_description = description;
}

void Movie::setId(const QString &id)
{
    m_id = id;
}

void Movie::setInfo(const QString &info)
{
    m_info = info;
}
