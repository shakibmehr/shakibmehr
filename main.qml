
import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.0
import QtLocation 5.6
import QtPositioning 5.6

Window {
    id : rootWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Map")

    function formatDistance(meters)
    {
        var dist = Math.round(meters)
        if (dist > 1000 ){
            if (dist > 100000){
                dist = Math.round(dist / 1000)
            }
            else{
                dist = Math.round(dist / 100)
                dist = dist / 10
            }
            dist = dist + " km"
        }
        else{
            dist = dist + " m"
        }
        return dist
    }


    function formatTime(sec)
    {
        var value = sec
        var seconds = value % 60
        value /= 60
        value = (value > 1) ? Math.round(value) : 0
        var minutes = value % 60
        value /= 60
        value = (value > 1) ? Math.round(value) : 0
        var hours = value
        if (hours > 0) value = hours + "h:"+ minutes + "m"
        else value = minutes + "min"
        return value
    }


    function calculateCoordinateRoute(startCoordinate, endCoordinate)
    {
        //! [routerequest0]
        // clear away any old data in the query
        routeQuery.clearWaypoints();

        // add the start and end coords as waypoints on the route
        routeQuery.addWaypoint(startCoordinate)
        routeQuery.addWaypoint(endCoordinate)
        routeQuery.travelModes = RouteQuery.CarTravel
        routeQuery.routeOptimizations = RouteQuery.FastestRoute

        //! [routerequest0]

        //! [routerequest0 feature weight]
        for (var i=0; i<9; i++) {
            routeQuery.setFeatureWeight(i, 0)
        }
        //for (var i=0; i<routeDialog.features.length; i++) {
        //    map.routeQuery.setFeatureWeight(routeDialog.features[i], RouteQuery.AvoidFeatureWeight)
        //}
        //! [routerequest0 feature weight]

        //! [routerequest1]
        routeModel.update();

        //! [routerequest1]
        //! [routerequest2]
        // center the map on the start coord
        map.center = startCoordinate;
        //! [routerequest2]
    }

    property alias routeQuery: routeQuery

    property var coord: [QtPositioning.coordinate(32.0483, 46.0695),QtPositioning.coordinate(33.0483, 44.0695),QtPositioning.coordinate(30.0483, 40.0695)]





    Plugin {
        id: mapPlugin
        name: "osm" // "mapboxgl", "esri", ...
        // specify plugin parameters if necessary
        // PluginParameter {
        //     name:
        //     value:
    }


    //    }
    Map {
        id:map
        anchors.fill: parent
        zoomLevel: 6
        plugin: Plugin {
            id:  mapPlugin1
            name: "mapbox"
            // configure your own map_id and access_token here
            parameters: [
                PluginParameter {
                    name: "mapbox.mapping.map_id"
                    value: "mapbox.streets"
                },
                PluginParameter {
                    name: "mapbox.access_token"
                    value: "pk.eyJ1IjoiZ3R2cGxheSIsImEiOiJjaWZ0Y2pkM2cwMXZqdWVsenJhcGZ3ZDl5In0.6xMVtyc0CkYNYup76iMVNQ"
                },
                PluginParameter {
                    name: "mapbox.mapping.highdpi_tiles"
                    value: true
                }
            ]
        }
        //center: QtPositioning.coordinate(33, 48)



        RouteModel {
            id: routeModel
            plugin : mapPlugin
            query:  RouteQuery {
                id: routeQuery
            }
            onStatusChanged: {
                if (status == RouteModel.Ready) {
                    switch (count) {
                    case 0:
                        // technically not an error
                      //  console.log("Route Error 0")
                        break
                    case 1:
                        // map.showRouteList()


                        break
                    }
                } else if (status == RouteModel.Error) {
                    //console.log("Route Error 1")
                }
            }
        }




        MapItemView {
            model: routeModel
            delegate: routeDelegate
            //! [routeview0]
            autoFitViewport: true
            //! [routeview1]
        }


        Component {
            id: routeDelegate

            MapRoute {
                id: route
                route: routeData
                line.color: "red"
                line.width: 5
                smooth: true
                opacity: 0.8
                //! [routedelegate0]
//                MouseArea {
//                    id: routeMouseArea
//                    anchors.fill: parent
//                    hoverEnabled: false
//                    property variant lastCoordinate

//                    onPressed : {
//                        map.lastX = mouse.x + parent.x
//                        map.lastY = mouse.y + parent.y
//                        map.pressX = mouse.x + parent.x
//                        map.pressY = mouse.y + parent.y
//                        lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
//                    }

//                    onPositionChanged: {
//                        if (mouse.button == Qt.LeftButton) {
//                            map.lastX = mouse.x + parent.x
//                            map.lastY = mouse.y + parent.y
//                        }
//                    }

//                    onPressAndHold:{
//                        if (Math.abs(map.pressX - parent.x- mouse.x ) < map.jitterThreshold
//                                && Math.abs(map.pressY - parent.y - mouse.y ) < map.jitterThreshold) {
//                            // showRouteMenu(lastCoordinate);
//                        }
//                    }

//                }
                //! [routedelegate1]
            }
        }


//        Component.onCompleted: {



//            var startCoordinate = QtPositioning.coordinate(32.0483, 46.0695);
//            var endCoordinate = QtPositioning.coordinate(33.9645, 48.671);

//            calculateCoordinateRoute(startCoordinate, endCoordinate)
//            if(routeModel.count > 1){
//                console.log("count: ",routeModel.get(0).segments.length)
//            }



//        }



        Column{
            spacing: 5
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            Button{
                text: "Route"
                onClicked: {
                    var startCoordinate1 = QtPositioning.coordinate(32.0483, 46.0695);
                    var endCoordinate1 = QtPositioning.coordinate(33.9645, 48.671);

                    calculateCoordinateRoute(startCoordinate1, endCoordinate1)

                    if(routeModel.count >= 1){
                        for (var i = 0; i < routeModel.get(0).segments.length; i++) {
//                        console.log("instruction : ",routeModel.get(0).segments[i].maneuver.instructionText)
//                        console.log("distance : ",formatDistance(routeModel.get(0).segments[i].maneuver.distanceToNextInstruction))
//                        console.log("path : ",formatDistance(routeModel.get(0).segments[i].path))
                        }
//                        console.log("travelTime : ",formatTime(routeModel.get(0).travelTime))
//                        console.log("distance : ",formatDistance(routeModel.get(0).distance))
//                        console.log("distance : ",routeModel.get(0).distance)
//                        console.log("bounds : ",routeModel.get(0).bounds)
//                        console.log("legs : ",routeModel.get(0).legs)
                      //    console.log("path  : ",routeModel.path )
                    }
                }
            }

            Button{
                text: "List"
             //   onClicked: console.log("List: ",routeModel.travelTime)
            }
        }



    }
}
