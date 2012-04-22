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

#ifndef THEATERLISTMODEL_H
#define THEATERLISTMODEL_H

#include <QAbstractListModel>

class Movie;

class TheaterListModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
    enum TheaterListRoles {
        MovieNameRole = Qt::UserRole + 1,
        MovieTimesRole,
        MovieDescriptionRole,
        MovieIdRole,
        MovieInfoRole,
        TheaterNameRole,
        TheaterInfoRole,
        MovieImdbIdRole
    };

    TheaterListModel(QObject *parent = 0);
    ~TheaterListModel();

    QVariant data(const QModelIndex &index, int role) const;

    int rowCount(const QModelIndex &parent = QModelIndex()) const;

    void setMovieShowtimes(QList<Movie> movies);

    QVariantMap get(const QModelIndex &index) const;

signals:
    void countChanged();

private:
    Q_DISABLE_COPY(TheaterListModel)
    QList<Movie> m_movies;
};

#endif // THEATERLISTMODEL_H
