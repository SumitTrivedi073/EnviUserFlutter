import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../web_service/Constant.dart';

class MapDirectionWidgetWithDriver extends StatefulWidget {
  @override
  _MapDirectionWidgetWithDriverState createState() =>
      _MapDirectionWidgetWithDriverState();
}

class _MapDirectionWidgetWithDriverState
    extends State<MapDirectionWidgetWithDriver> {
  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = GoogleApiKey;

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  LatLng startLocation = const LatLng(13.197965663195877, 77.70646809992469);
  LatLng endLocation = const LatLng(12.976741996846226, 77.59929091535592);

  @override
  void initState() {
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(startLocation.toString()),
      position: startLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Start Marker',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen), //Icon for Marker
    ));

    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Destination Point ',
        snippet: 'Destination Marker',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed), //Icon for Marker
    ));

    getDirections(); //fetch direction polylines from Google API

    super.initState();
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
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
    return Scaffold(
      body: GoogleMap(
        //Map widget from google_maps_flutter package
        //enable Zoom in, out on map
        initialCameraPosition: CameraPosition(
          //innital position in map
          target: startLocation, //initial position
          zoom: 10.0, //initial zoom level
        ),
        markers: markers,
        //markers to show on map
        polylines: Set<Polyline>.of(polylines.values),
        //polylines
        mapType: MapType.normal,
        rotateGesturesEnabled: true,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        //map type
        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
