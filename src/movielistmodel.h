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

#ifndef MOVIELISTMODEL_H
#define MOVIELISTMODEL_H

#include <QAbstractListModel>

class Movie;

//! \class MovieListModel
//! \brief MovieListModel is a model for the available movies showing in a cinema
//!
//! The model exposes brief movie information for movies showing in a cinema,
//! such as name, showtimes, and -when available- genre, description or an IMDB
//! identifier
class MovieListModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:

    //! Enum for supported roles
    enum MovieListRoles {
        MovieIdRole = Qt::UserRole + 1, //!< Movie identifier role
        MovieImdbIdRole,                //!< IMDB identifier role
        MovieNameRole,                  //!< Movie name role
        MovieInfoRole,                  //!< Movie info role
        MovieTimesRole,                 //!< Movie showtimes role
        MovieDescriptionRole            //!< Movie description role
    };

    //! Constructor
    explicit MovieListModel(QObject* parent = 0);

    //! Destructor
    ~MovieListModel();

    //! \reimp
    QVariant data(const QModelIndex& index, int role) const;

    //! \reimp
    int rowCount(const QModelIndex& index = QModelIndex()) const;

#if (QT_VERSION >= QT_VERSION_CHECK(5, 0, 0))
    //! \reimp
    QHash<int, QByteArray> roleNames() const;
#endif

    //! Convenience method which provides a QVariantMap for the movie
    //! at the given index
    //!
    //! \param index The index for the movie to fetch
    //! \return A QVariantMap with all the information about the movie
    QVariantMap get(const QModelIndex& index) const;

    //! Sets a movie list to the model
    //! \param movies The list of movies to set to the model
    void setMovieList(QList<Movie> movies);

signals:
    //! Signal notifying that the movie count has changed
    void countChanged();

private:
    Q_DISABLE_COPY(MovieListModel)
    QList<Movie> m_movies;
    QHash<int, QByteArray> m_roles;
};

#endif // MOVIELISTMODEL_H
