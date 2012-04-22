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
    const QModelIndex rowIndex = sourceModel()->index(sourceRow, 0);

    const QString movieName =
            sourceModel()->data(rowIndex,
                                TheaterListModel::MovieNameRole).toString();
    const QString movieDescription =
            sourceModel()->data(rowIndex,
                                TheaterListModel::MovieDescriptionRole).toString();
    const QString theaterName =
            sourceModel()->data(rowIndex,
                                TheaterListModel::TheaterNameRole).toString();

    return (movieName.contains(filterRegExp()) ||
            movieDescription.contains(filterRegExp()) ||
            theaterName.contains(filterRegExp()));
}

QVariantMap SortFilterModel::get(int sourceRow) const
{
    const TheaterListModel* source = qobject_cast<const TheaterListModel*>(sourceModel());
    const QModelIndex index = source->index(sourceRow, 0);
    return source->get(index);
}
