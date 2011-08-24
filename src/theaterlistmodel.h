#ifndef THEATERLISTMODEL_H
#define THEATERLISTMODEL_H

#include <QAbstractListModel>

class Movie;

class TheaterListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum TheaterListRoles {
        MovieNameRole = Qt::UserRole + 1,
        MovieTimesRole,
        MovieDescriptionRole,
        TheaterNameRole,
        TheaterInfoRole
    };

    TheaterListModel(QObject *parent = 0);
    ~TheaterListModel();

    QVariant data(const QModelIndex &index, int role) const;

    int rowCount(const QModelIndex &parent = QModelIndex()) const;

    void addMovie(Movie *movie);

    void clear();

private:
    Q_DISABLE_COPY(TheaterListModel)
    QList<Movie*> m_movies;
};

#endif // THEATERLISTMODEL_H
