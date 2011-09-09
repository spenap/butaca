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

    // We search on movie name and description and theater name.
    // Theater info and movie times are ignored when searching.
    QModelIndex movieNameIndex = sourceModel()->index(sourceRow, 0);
    QModelIndex movieDescriptionIndex = sourceModel()->index(sourceRow, 0);
    QModelIndex theaterNameIndex = sourceModel()->index(sourceRow, 0);

    return (sourceModel()->data(movieNameIndex, TheaterListModel::MovieNameRole).toString().contains(filterRegExp()) ||
            sourceModel()->data(movieDescriptionIndex, TheaterListModel::MovieDescriptionRole).toString().contains(filterRegExp()) ||
            sourceModel()->data(theaterNameIndex, TheaterListModel::TheaterNameRole).toString().contains(filterRegExp()));
}
