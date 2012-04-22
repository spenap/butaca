#ifndef MOVIE_H
#define MOVIE_H

#include <QString>

class Movie
{
public:
    const QString movieName() const;
    const QString movieTimes() const;
    const QString movieDescription() const;
    const QString movieId() const;
    const QString movieInfo() const;
    const QString movieImdbId() const;
    const QString theaterName() const;
    const QString theaterInfo() const;

    void setMovieName(const QString &name);
    void setMovieTimes(const QString &times);
    void setMovieDescription(const QString &description);
    void setMovieId(const QString &id);
    void setMovieInfo(const QString &info);
    void setMovieImdbId(const QString &imdbId);
    void setTheaterName(const QString &name);
    void setTheaterInfo(const QString &info);

private:
    QString m_movieName;
    QString m_movieTimes;
    QString m_movieDescription;
    QString m_movieId;
    QString m_movieInfo;
    QString m_movieImdbId;
    QString m_theaterName;
    QString m_theaterInfo;
};

#endif // MOVIE_H
