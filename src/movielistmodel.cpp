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

#include "movielistmodel.h"
#include "movie.h"

#include <QDebug>

MovieListModel::MovieListModel(QObject* parent) :
    QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles[MovieIdRole] = "id";
    roles[MovieImdbIdRole] = "imdbId";
    roles[MovieNameRole] = "name";
    roles[MovieInfoRole] = "info";
    roles[MovieTimesRole] = "showtimes";
    roles[MovieDescriptionRole] = "description";
    setRoleNames(roles);
}

MovieListModel::~MovieListModel()
{
}

QVariant MovieListModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() >= m_movies.count()) {
        return QVariant();
    }

    const Movie& movie = m_movies.at(index.row());

    switch (role) {
    case MovieIdRole:
        return QVariant::fromValue(movie.id());
    case MovieImdbIdRole:
        return QVariant::fromValue(movie.imdbId());
    case MovieNameRole:
        return QVariant::fromValue(movie.name());
    case MovieInfoRole:
        return QVariant::fromValue(movie.info());
    case MovieTimesRole:
        return QVariant::fromValue(movie.showtimes());
    case MovieDescriptionRole:
        return QVariant::fromValue(movie.description());
    default:
        qDebug() << Q_FUNC_INFO << "Unhandled role" << role;
        return QVariant();
    }
}

int MovieListModel::rowCount(const QModelIndex& index) const
{
    Q_UNUSED(index)
    return m_movies.count();
}

QVariantMap MovieListModel::get(const QModelIndex& index) const
{
    QVariantMap mappedEntry;

    if (!index.isValid() || index.row() >= m_movies.count()) {
        return mappedEntry;
    }

    const Movie& movie = m_movies.at(index.row());
    const QHash<int, QByteArray>& roles = roleNames();

    mappedEntry[roles[MovieIdRole]] = movie.id();
    mappedEntry[roles[MovieImdbIdRole]] = movie.imdbId();
    mappedEntry[roles[MovieNameRole]] = movie.name();
    mappedEntry[roles[MovieInfoRole]] = movie.info();
    mappedEntry[roles[MovieTimesRole]] = movie.showtimes();
    mappedEntry[roles[MovieDescriptionRole]] = movie.description();
    return mappedEntry;
}

void MovieListModel::setMovieList(QList<Movie> movies)
{
    if (m_movies.count() > 0) {
        beginRemoveRows(QModelIndex(), 0, m_movies.count() - 1);
        m_movies.clear();
        endRemoveRows();
    }

    if (movies.count() > 0) {
        beginInsertRows(QModelIndex(), 0, m_movies.count() - 1);
        m_movies << movies;
        endInsertRows();
    }

    emit countChanged();
}
