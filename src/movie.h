#ifndef MOVIE_H
#define MOVIE_H

#include <QObject>

class Movie : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString movieName READ movieName WRITE setMovieName)
    Q_PROPERTY(QString movieTimes READ movieTimes WRITE setMovieTimes)
    Q_PROPERTY(QString movieDescription READ movieDescription WRITE setMovieDescription)
    Q_PROPERTY(QString theaterName READ theaterName WRITE setTheaterName)
    Q_PROPERTY(QString theaterInfo READ theaterInfo WRITE setTheaterInfo)

public:
    Movie();

    const QString &movieName() const;
    const QString &movieTimes() const;
    const QString &movieDescription() const;
    const QString &theaterName() const;
    const QString &theaterInfo() const;

    void setMovieName(const QString &name);
    void setMovieTimes(const QString &times);
    void setMovieDescription(const QString &description);
    void setTheaterName(const QString &name);
    void setTheaterInfo(const QString &info);

private:
    QString m_movieName;
    QString m_movieTimes;
    QString m_movieDescription;
    QString m_theaterName;
    QString m_theaterInfo;
};

#endif // MOVIE_H
