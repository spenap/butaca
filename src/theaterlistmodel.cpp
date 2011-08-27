#include "theaterlistmodel.h"
#include "movie.h"

TheaterListModel::TheaterListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    QHash<int, QByteArray> roles;
    roles[MovieNameRole] = "title";
    roles[MovieTimesRole] = "subtitle";
    roles[MovieDescriptionRole] = "movieDescription";
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

    Movie *movie = m_movies.at(index.row());

    switch (role) {
    case MovieNameRole:
        return QVariant::fromValue(movie->movieName());
    case MovieTimesRole:
        return QVariant::fromValue(movie->movieTimes());
    case MovieDescriptionRole:
        return QVariant::fromValue(movie->movieDescription());
    case TheaterNameRole:
        return QVariant::fromValue(movie->theaterName());
    case TheaterInfoRole:
        return QVariant::fromValue(movie->theaterInfo());
    default:
        return QVariant();
    }
}

void TheaterListModel::setMovieShowtimes(QList<Movie*> movies)
{
    if (m_movies.count() > 0) {
        beginRemoveRows(QModelIndex(), 0, m_movies.count() - 1);
        qDeleteAll(m_movies.begin(), m_movies.end());
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
