#include "movie.h"

const QString Movie::movieName() const
{
    return m_movieName;
}

const QString Movie::movieTimes() const
{
    return m_movieTimes;
}

const QString Movie::movieDescription() const
{
    return m_movieDescription;
}

const QString Movie::theaterName() const
{
    return m_theaterName;
}

const QString Movie::theaterInfo() const
{
    return m_theaterInfo;
}

void Movie::setMovieName(const QString &name)
{
    m_movieName = name;
}

void Movie::setMovieTimes(const QString &times)
{
    m_movieTimes = times;
}

void Movie::setMovieDescription(const QString &description)
{
    m_movieDescription = description;
}

void Movie::setTheaterName(const QString &name)
{
    m_theaterName = name;
}

void Movie::setTheaterInfo(const QString &info)
{
    m_theaterInfo = info;
}
