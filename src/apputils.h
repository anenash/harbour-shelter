#ifndef APPUTILS_H
#define APPUTILS_H

#include <QObject>

class AppUtils : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString token READ token)
    Q_PROPERTY(QString marker READ marker)

public:
    explicit AppUtils(QObject *parent = nullptr);

    QString token() { return m_token; }
    QString marker() { return m_marker; }

signals:

public slots:

private:
    QString m_token;
    QString m_marker;
};

#endif // APPUTILS_H
