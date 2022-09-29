import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:envi/provider/model/tripDataModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../web_service/Constant.dart';

class MapDirectionWidgetWithDriver extends StatefulWidget {
  TripDataModel? liveTripData;

  MapDirectionWidgetWithDriver({Key? key, this.liveTripData}) : super(key: key);

  @override
  _MapDirectionWidgetWithDriverState createState() =>
      _MapDirectionWidgetWithDriverState();
}

class _MapDirectionWidgetWithDriverState
    extends State<MapDirectionWidgetWithDriver> {
  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = GoogleApiKey;
  late Timer timer;
  int count = 1;

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  late LatLng startLocation = LatLng(
      (widget.liveTripData!.tripInfo!.pickupLocation!.latitude != null)
          ? widget.liveTripData!.tripInfo!.pickupLocation!.latitude!
          : 13.197965663195877,
      (widget.liveTripData!.tripInfo!.pickupLocation!.longitude != null)
          ? widget.liveTripData!.tripInfo!.pickupLocation!.longitude!
          : 77.70646809992469);
  late LatLng endLocation = LatLng(
      (widget.liveTripData!.tripInfo!.dropLocation!.latitude != null)
          ? widget.liveTripData!.tripInfo!.dropLocation!.latitude!
          : 12.976741996846226,
      (widget.liveTripData!.tripInfo!.dropLocation!.longitude != null)
          ? widget.liveTripData!.tripInfo!.dropLocation!.longitude!
          : 77.59929091535592);

  late LatLng carLocation = LatLng(
      (widget.liveTripData!.driverLocation!.latitude != null)
          ? widget.liveTripData!.driverLocation!.latitude!
          : 14.063446041067092,
      (widget.liveTripData!.driverLocation!.longitude != null)
          ? widget.liveTripData!.driverLocation!.longitude!
          : 77.345492878187);

  @override
  void initState() {
    addMarker();
    getDirections();
    //fetch direction polylines from Google API
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
    startTimer();
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
          zoom: 9.0, //initial zoom level
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

  Future<void> addMarker() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/car-map.png', 70);

    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(startLocation.toString()),
      position: startLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Pickup Location',
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
        title: 'Destination Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed), //Icon for Marker
    ));

    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(carLocation.toString()),
      position: carLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Driver Location',
      ),
      icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
    ));

    setState(() {
      //refresh UI
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void startTimer() {
    timer = Timer.periodic(
        const Duration(minutes: 5),
        (Timer t) => {
              if (count <= 10) {getDirections(), count++}
            });
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
