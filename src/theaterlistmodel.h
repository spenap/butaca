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

class Cinema;
class MovieListModel;

//! \class TheaterListModel
//! \brief TheaterListModel is a model for the available cinemas
//!
//! The model exposes brief information for cinemas in the surrounding areas,
//! such as name, address and movies playing there
class TheaterListModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:

    //! Enum for supported roles
    enum TheaterListRoles {
        TheaterNameRole = Qt::UserRole + 1, //!< Cinema name role
        TheaterInfoRole,                    //!< Cinema info role
        TheaterMovieListRole                //!< Movie list role
    };

    //! Constructor
    TheaterListModel(QObject* parent = 0);

    //! Destructor
    ~TheaterListModel();

    //! \reimp
    QVariant data(const QModelIndex& index, int role) const;

    //! \reimp
    int rowCount(const QModelIndex& index = QModelIndex()) const;

#if (QT_VERSION >= QT_VERSION_CHECK(5, 0, 0))
    //! \reimp
    QHash<int, QByteArray> roleNames() const;
#endif

    //! Sets a cinema list to the model
    //! \param cinemas The list of cinemas to set to the model
    void setCinemaList(QList<Cinema> cinemas);

    //! Convenience method which provides a QVariantMap for the cinema
    //! at the given index
    //!
    //! \param index The index for the cinema to fetch
    //! \return A QVariantMap with all the information about the cinema
    QVariantMap get(const QModelIndex& index) const;

    //! Convenience method which provides the showtimes for the cinema at the
    //! given row
    //! \param index The index to retrieve the showtimes at
    //! \return A MovieListModel for the cinema at the given index
    MovieListModel* showtimes(const QModelIndex& index);

signals:
    //! Signal notifying that the cinemas count has changed
    void countChanged();

private:
    Q_DISABLE_COPY(TheaterListModel)
    QList<Cinema> m_cinemas;
    MovieListModel* m_currentMovieListModel;
    QHash<int, QByteArray> m_roles;
};

#endif // THEATERLISTMODEL_H
