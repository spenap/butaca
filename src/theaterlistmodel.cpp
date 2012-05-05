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
#include "cinema.h"

TheaterListModel::TheaterListModel(QObject* parent)
    : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles[TheaterNameRole] = "name";
    roles[TheaterInfoRole] = "info";
    setRoleNames(roles);
}

TheaterListModel::~TheaterListModel()
{
}

int TheaterListModel::rowCount(const QModelIndex& index) const
{
    Q_UNUSED(index)
    return m_cinemas.count();
}

QVariant TheaterListModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() >= m_cinemas.count()) {
        return QVariant();
    }

    const Cinema& cinema = m_cinemas.at(index.row());

    switch (role) {
    case TheaterNameRole:
        return QVariant::fromValue(cinema.name());
    case TheaterInfoRole:
        return QVariant::fromValue(cinema.info());
    default:
        return QVariant();
    }
}

void TheaterListModel::setCinemaList(QList<Cinema> cinemas)
{
    if (m_cinemas.count() > 0) {
        beginRemoveRows(QModelIndex(), 0, m_cinemas.count() - 1);
        m_cinemas.clear();
        endRemoveRows();
    }

    if (cinemas.count() > 0) {
        beginInsertRows(QModelIndex(), 0, cinemas.count() - 1);
        m_cinemas << cinemas;
        endInsertRows();
    }

    emit countChanged();
}

QVariantMap TheaterListModel::get(const QModelIndex &index) const
{
    QVariantMap mappedEntry;

    if (!index.isValid() || index.row() >= m_cinemas.count()) {
        return mappedEntry;
    }

    const Cinema& cinema = m_cinemas.at(index.row());
    const QHash<int, QByteArray>& roles = roleNames();

    mappedEntry[roles[TheaterNameRole]] = cinema.name();
    mappedEntry[roles[TheaterInfoRole]] = cinema.info();

    return mappedEntry;
}
