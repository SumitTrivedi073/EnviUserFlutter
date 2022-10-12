
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:uuid/uuid.dart';

import '../../direction_model/directionModel.dart';
import '../../sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';

import '../../web_service/APIDirectory.dart';
import '../../web_service/Constant.dart';

class MapDirectionWidget extends StatefulWidget{
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;

  const MapDirectionWidget({Key? key, this.toAddress, this.fromAddress}) : super(key: key);

  @override
  _MapDirectionWidgetState createState() => _MapDirectionWidgetState();
}

class _MapDirectionWidgetState extends State<MapDirectionWidget> {

  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = GoogleApiKey;

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction


  late LatLng pickupLocation = LatLng(widget.fromAddress!.latLng.latitude, widget.fromAddress!.latLng.longitude);
  late  LatLng destinationLocation =  LatLng(widget.toAddress!.latLng.latitude, widget.toAddress!.latLng.longitude);
  late String _sessionToken;
  var uuid = const Uuid();



  @override
  void initState() {
    _sessionToken = uuid.v4();
    markers.add(Marker( //add start location marker
      markerId: MarkerId(pickupLocation.toString()),
      position: pickupLocation, //position of marker
      infoWindow: const InfoWindow( //popup info
        title: 'Pickup Location ',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), //Icon for Marker
    ));

    markers.add(Marker( //add distination location marker
      markerId: MarkerId(destinationLocation.toString()),
      position: destinationLocation, //position of marker
      infoWindow: const InfoWindow( //popup info
        title: 'Destination Location ',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), //Icon for Marker
    ));

    getDirections(); //fetch direction polylines from Google API

    super.initState();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    String request =
        '$directionBaseURL?origin=${pickupLocation.latitude},${pickupLocation.longitude}&destination=${destinationLocation.latitude},${destinationLocation.longitude}&mode=driving&transit_routing_preference=less_driving&sessiontoken=$_sessionToken&key=$googleAPiKey';
    var url = Uri.parse(request);
    dynamic response = await HTTP.get(url);
    if (response != null && response != null) {
      if (response.statusCode == 200) {
        DirectionModel directionModel = DirectionModel.fromJson(json.decode(response.body) );
        List<PointLatLng> pointLatLng = [];

        for (var i = 0; i < directionModel.routes.length; i++) {

          for (var j = 0; j < directionModel.routes[i].legs.length; j++) {
            for (var k = 0; k < directionModel.routes[i].legs[j].steps.length; k++) {
              pointLatLng =   polylinePoints.decodePolyline(directionModel.routes[i].legs[j].steps[k].polyline.points);
              for (var point in pointLatLng) {
                polylineCoordinates.add(LatLng(point.latitude, point.longitude));
              }
            }
          }
        }
        addPolyLine(polylineCoordinates);
      } else {
        throw Exception('Failed to load predictions');
      }
    }
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.green,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GoogleMap( //Map widget from google_maps_flutter package
        zoomGesturesEnabled: true, //enable Zoom in, out on map
        initialCameraPosition: CameraPosition( //innital position in map
          target: pickupLocation, //initial position
          zoom: 10.0, //initial zoom level
        ),
        markers: markers, //markers to show on map
        polylines: Set<Polyline>.of(polylines.values), //polylines
        mapType: MapType.normal,
        rotateGesturesEnabled: true,
        zoomControlsEnabled: false,//map type
        onMapCreated: (controller) { //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
