#ifndef IMAGESAVER_H
#define IMAGESAVER_H

#include <QObject>

class ImageSaver
{
public:
    void save(QObject *item, const QString &fileName);

};

#endif // IMAGESAVER_H
