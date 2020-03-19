#ifndef QMYBITMAP_H
#define QMYBITMAP_H

#include <QObject>
#include <QQuickPaintedItem>
#include <QQuickItem>
#include <QPainter>
#include <QImage>

class QMyBitMap : public QObject
{
    Q_OBJECT
        Q_PROPERTY(QImage image READ image WRITE setImage NOTIFY imageChanged)
public:
    explicit QMyBitMap(QObject *parent = nullptr);
    Q_INVOKABLE void setImage(const QImage &image);
    void paint(QPainter *painter);
    QImage image() const;

signals:
void imageChanged();

public slots:

private:
    QImage current_image;
};

#endif // QMYBITMAP_H
