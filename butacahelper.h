#ifndef BUTACAHELPER_H
#define BUTACAHELPER_H

#include <QObject>

class ButacaHelper : public QObject
{
    Q_OBJECT
public:
    explicit ButacaHelper(QObject *parent = 0);

public slots:
    void openVideo(QString url);
};

#endif // BUTACAHELPER_H
