#ifndef MOVIE_H
#define MOVIE_H

#include <QString>

class Movie
{
public:
    const QString movieName() const;
    const QString movieTimes() const;
    const QString movieDescription() const;
    const QString theaterName() const;
    const QString theaterInfo() const;

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
