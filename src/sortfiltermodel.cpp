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

#include "sortfiltermodel.h"
#include "theaterlistmodel.h"

SortFilterModel::SortFilterModel(QObject *parent) :
    QSortFilterProxyModel (parent)
{
    setFilterCaseSensitivity(Qt::CaseInsensitive);
}

SortFilterModel::~SortFilterModel()
{
}

bool SortFilterModel::filterAcceptsRow(int sourceRow,
                                       const QModelIndex &sourceParent) const
{
    Q_UNUSED(sourceParent)

    // We search on theater name
    const QModelIndex rowIndex = sourceModel()->index(sourceRow, 0);

    const QString theaterName =
            sourceModel()->data(rowIndex,
                                TheaterListModel::TheaterNameRole).toString();

    return theaterName.contains(filterRegExp());
}

QVariantMap SortFilterModel::get(int sourceRow) const
{
    const TheaterListModel* source = qobject_cast<const TheaterListModel*>(sourceModel());
    const QModelIndex index = source->index(sourceRow, 0);
    return source->get(index);
}
