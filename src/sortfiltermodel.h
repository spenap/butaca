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

#ifndef SORTFILTERMODEL_H
#define SORTFILTERMODEL_H

#include <QSortFilterProxyModel>

//! \class SortFilterModel
//! \brief SortFilterModel is a proxy model for the model of cinemas around you
//!
//! The sort filter model allows filtering the cinemas model which proxies,
//! also forwarding the methods to it
class SortFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
public:
    //! Constructor
    SortFilterModel(QObject* parent = 0);

    //! Destructor
    ~SortFilterModel();

public Q_SLOTS:
    //! Convenience method which provides a QVariantMap for the cinema
    //! at the given index
    //!
    //! \param sourceRow The index for the cinema to fetch
    //! \return A QVariantMap with all the information about the cinema
    QVariantMap get(int sourceRow) const;

    //! Convenience method which provides the showtimes for the cinema at the
    //! given row
    //! \param index The index to retrieve the showtimes at
    //! \return A MovieListModel, as QObject*, for the cinema at the given index
    QObject* showtimes(int sourceRow);

signals:
    //! Signal notifying that the cinemas count has changed
    void countChanged();

protected:
    //! \reimp
    bool filterAcceptsRow(int sourceRow, const QModelIndex& parent) const;
};

#endif // SORTFILTERMODEL_H
