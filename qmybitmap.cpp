#include "qmybitmap.h"

QMyBitMap::QMyBitMap(QObject *parent) : QObject(parent)
{
    this->current_image = QImage(":/1.png");
}

void QMyBitMap::setImage(const QImage &image)
{
    this->current_image = image;
   // update();
}

void QMyBitMap::paint(QPainter *painter)
{
    QRectF bounding_rect ;
    QImage scaled = this->current_image.scaledToHeight(bounding_rect.height());
    QPointF center = bounding_rect.center() - scaled.rect().center();

    if(center.x() < 0)
        center.setX(0);
    if(center.y() < 0)
        center.setY(0);
   painter->drawImage(center, scaled);
}

QImage QMyBitMap::image() const
{
    return this->current_image;
}
