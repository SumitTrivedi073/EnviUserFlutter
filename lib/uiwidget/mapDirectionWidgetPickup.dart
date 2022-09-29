import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:envi/provider/model/tripDataModel.dart';
import 'package:envi/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart';

import '../web_service/Constant.dart';

class MapDirectionWidgetPickup extends StatefulWidget {
  TripDataModel? liveTripData;

  MapDirectionWidgetPickup({Key? key, this.liveTripData}) : super(key: key);

  @override
  _MapDirectionWidgetPickupState createState() =>
      _MapDirectionWidgetPickupState();
}

class _MapDirectionWidgetPickupState
    extends State<MapDirectionWidgetPickup> with TickerProviderStateMixin {
  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = GoogleApiKey;
  late Timer timer;
  int count = 1;

  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  late LatLng startLocation = LatLng(
      (widget.liveTripData!.tripInfo!.pickupLocation!.latitude != null)
          ? widget.liveTripData!.tripInfo!.pickupLocation!.latitude!
          : 13.197965663195877,
      (widget.liveTripData!.tripInfo!.pickupLocation!.longitude != null)
          ? widget.liveTripData!.tripInfo!.pickupLocation!.longitude!
          : 77.70646809992469);
  
  late LatLng carLocation = LatLng(
      (widget.liveTripData!.driverLocation!.latitude != null)
          ? widget.liveTripData!.driverLocation!.latitude!
          : 14.063446041067092,
      (widget.liveTripData!.driverLocation!.longitude != null)
          ? widget.liveTripData!.driverLocation!.longitude!
          : 77.345492878187);

  final List<Marker> markers = <Marker>[];
  Animation<double>? _animation;
  final _mapMarkerSC = StreamController<List<Marker>>();
  StreamSink<List<Marker>> get mapMarkerSink => _mapMarkerSC.sink;
  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;
  double distance = 0.0;

  @override
  void initState() {
    //fetch direction polylines from Google API
    super.initState();

    addMarker();
    getDirections();
    if (mapController != null) {
      animateCar(
        carLocation.latitude,
        carLocation.longitude,
        startLocation.latitude,
        startLocation.longitude,
        mapMarkerSink,
        this,
        mapController!,
      );
      setState(() {});
    }
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(carLocation.latitude, carLocation.longitude),
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

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: AppColor.darkGreen,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;

    double totalDistance = 0.0;
    for(var i = 0; i < polylineCoordinates.length-1; i++){
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i+1].latitude,
          polylineCoordinates[i+1].longitude);
    }
    print("totalDistance=======>$totalDistance");

    distance = totalDistance;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final googleMap = StreamBuilder<List<Marker>>(
        stream: mapMarkerStream,
        builder: (context, snapshot) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: carLocation, //initial position
              zoom: 15.0, //initial zoom level
            ),
            polylines: Set<Polyline>.of(polylines.values),
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: Set<Marker>.of(snapshot.data ?? []),
            padding: const EdgeInsets.all(8),
          );
        });

    return Scaffold(
      body: Stack(
        children: [
          googleMap,
        ],
      ),
    );
  }

  addMarker() async {
    var pickupMarker = Marker(
      //add start location marker
      markerId: MarkerId(startLocation.toString()),
      position: startLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Pickup Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen), //Icon for Marker
    );


    final Uint8List markerIcon =
    await getBytesFromAsset('assets/images/car-map.png', 70);

    var carMarker = Marker(
        markerId: const MarkerId("driverMarker"),
        position: carLocation,
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: const Offset(0.5, 0.5),
        flat: true,
        rotation: getBearing(carLocation,startLocation),
        draggable: false);


    //Adding a delay and then showing the marker on screen
    await Future.delayed(const Duration(milliseconds: 500));

    markers.add(pickupMarker);
    markers.add(carMarker);

    mapMarkerSink.add(markers);
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

  animateCar(
    double fromLat, //Starting latitude
    double fromLong, //Starting longitude
    double toLat, //Ending latitude
    double toLong, //Ending longitude
    StreamSink<List<Marker>>
        mapMarkerSink, //Stream build of map to update the UI
    TickerProvider
        provider, //Ticker provider of the widget. This is used for animation
    GoogleMapController controller, //Google map controller of our widget
  ) async {
    final double bearing =
        getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));

    markers.clear();

    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/car-map.png', 70);

    var carMarker = Marker(
        markerId: const MarkerId("driverMarker"),
        position: LatLng(fromLat, fromLong),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: const Offset(0.5, 0.5),
        flat: true,
        rotation: bearing,
        draggable: false);

    //Adding initial marker to the start location.
    markers.add(carMarker);
    mapMarkerSink.add(markers);

    final animationController = AnimationController(
      duration: const Duration(seconds: 5), //Animation duration of marker
      vsync: provider, //From the widget
    );

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController)
      ..addListener(() async {
        //We are calculating new latitude and logitude for our marker
        final v = _animation!.value;
        double lng = v * toLong + (1 - v) * fromLong;
        double lat = v * toLat + (1 - v) * fromLat;
        LatLng newPos = LatLng(lat, lng);

        //Removing old marker if present in the marker array
        if (markers.contains(carMarker)) markers.remove(carMarker);

        //New marker location
        carMarker = Marker(
            markerId: const MarkerId("driverMarker"),
            position: newPos,
            icon: BitmapDescriptor.fromBytes(markerIcon),
            anchor: const Offset(0.5, 0.5),
            flat: true,
            rotation: bearing,
            draggable: false);

        //Adding new marker to our list and updating the google map UI.
        markers.add(carMarker);
        mapMarkerSink.add(markers);

        //Moving the google camera to the new animated location.
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: newPos, zoom: 15.5)));
      });

    //Starting the animation
    animationController.forward();
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return degrees(atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - degrees(atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return degrees(atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - degrees(atan(lng / lat))) + 270;
    }
    return -1;
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
