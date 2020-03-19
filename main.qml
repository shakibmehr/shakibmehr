
import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtLocation 5.5
import QtPositioning 5.5
Window {
    id : rootWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Map")
    property int mapWidth: rootWindow.width
    property int mapHeight: rootWindow.height

}
