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

#include "theaterlistmodel.h"
#include "movie.h"

TheaterListModel::TheaterListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles[MovieNameRole] = "title";
    roles[MovieTimesRole] = "subtitle";
    roles[MovieDescriptionRole] = "movieDescription";
    roles[MovieIdRole] = "movieId";
    roles[MovieInfoRole] = "movieInfo";
    roles[MovieImdbIdRole] = "movieImdbId";
    roles[TheaterNameRole] = "theaterName";
    roles[TheaterInfoRole] = "theaterInfo";
    setRoleNames(roles);
}

TheaterListModel::~TheaterListModel()
{
}

int TheaterListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_movies.count();
}

QVariant TheaterListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    if (index.row() >= m_movies.count()) {
        return QVariant();
    }

    const Movie& movie = m_movies.at(index.row());

    switch (role) {
    case MovieNameRole:
        return QVariant::fromValue(movie.movieName());
    case MovieTimesRole:
        return QVariant::fromValue(movie.movieTimes());
    case MovieDescriptionRole:
        return QVariant::fromValue(movie.movieDescription());
    case MovieIdRole:
        return QVariant::fromValue(movie.movieId());
    case MovieInfoRole:
        return QVariant::fromValue(movie.movieInfo());
    case MovieImdbIdRole:
        return QVariant::fromValue(movie.movieImdbId());
    case TheaterNameRole:
        return QVariant::fromValue(movie.theaterName());
    case TheaterInfoRole:
        return QVariant::fromValue(movie.theaterInfo());
    default:
        return QVariant();
    }
}

void TheaterListModel::setMovieShowtimes(QList<Movie> movies)
{
    if (m_movies.count() > 0) {
        beginRemoveRows(QModelIndex(), 0, m_movies.count() - 1);
        m_movies.clear();
        endRemoveRows();
    }

    if (movies.count() > 0) {
        beginInsertRows(QModelIndex(), 0, movies.count() - 1);
        m_movies << movies;
        endInsertRows();
    }

    emit countChanged();
}

QVariantMap TheaterListModel::get(const QModelIndex &index) const
{
    QVariantMap mappedEntry;

    if (!index.isValid() || index.row() >= m_movies.count()) {
        return mappedEntry;
    }

    const Movie& movie = m_movies.at(index.row());
    mappedEntry.insert("title", movie.movieName());
    mappedEntry.insert("subtitle", movie.movieTimes());
    mappedEntry.insert("movieDescription", movie.movieDescription());
    mappedEntry.insert("movieId", movie.movieId());
    mappedEntry.insert("movieInfo", movie.movieInfo());
    mappedEntry.insert("movieImdbId", movie.movieImdbId());
    mappedEntry.insert("theaterName", movie.theaterName());
    mappedEntry.insert("theaterInfo", movie.theaterInfo());
    return mappedEntry;
}
