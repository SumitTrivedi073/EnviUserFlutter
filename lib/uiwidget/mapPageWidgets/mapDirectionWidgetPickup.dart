import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:envi/appConfig/appConfig.dart';
import 'package:envi/provider/model/tripDataModel.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math.dart';

import '../../direction_model/directionModel.dart';
import '../../direction_model/leg.dart';
import '../../web_service/APIDirectory.dart';
import '../../web_service/Constant.dart';

int GOOGLE_API_INVOCATION_LIMIT =
    AppConfig().getgoogleDirectionDriverIntervalMaxTrialCount();
int GOOGLE_API_INNTERVAL_MINUTES =
    AppConfig().getgoogleDirectionDriverIntervalInMin();

class MapDirectionWidgetPickup extends StatefulWidget {
  TripDataModel? liveTripData;
  final void Function(String) callback;

  MapDirectionWidgetPickup(
      {Key? key, this.liveTripData, required this.callback})
      : super(key: key);

  @override
  MapDirectionWidgetPickupState createState() =>
      MapDirectionWidgetPickupState();
}

class MapDirectionWidgetPickupState extends State<MapDirectionWidgetPickup>
    with TickerProviderStateMixin {
  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = GoogleApiKey;
  Timer? timer;
  int GOOGLE_API_INVOCATIONS = 1;
  late String _sessionToken;
  var uuid = const Uuid();
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  List<LatLng> polylineCoordinates = [];

  late LatLng pickupLocation = LatLng(
      (widget.liveTripData!.tripInfo!.pickupLocation!.latitude != null)
          ? widget.liveTripData!.tripInfo!.pickupLocation!.latitude
          : 13.197965663195877,
      (widget.liveTripData!.tripInfo!.pickupLocation!.longitude != null)
          ? widget.liveTripData!.tripInfo!.pickupLocation!.longitude
          : 77.70646809992469);

  late LatLng carCurrentLocation = LatLng(
      (widget.liveTripData!.driverLocation!.latitude != null)
          ? widget.liveTripData!.driverLocation!.latitude
          : 14.063446041067092,
      (widget.liveTripData!.driverLocation!.longitude != null)
          ? widget.liveTripData!.driverLocation!.longitude
          : 77.345492878187);

  late LatLng previousLocation = const LatLng(0.0, 0.0);
  var carMarker, driverStartingLocation;
  final List<Marker> markers = <Marker>[];
  AnimationController? animationController;
  Animation<double>? _animation;
  final _mapMarkerSC = StreamController<List<Marker>>();

  StreamSink<List<Marker>> get mapMarkerSink => _mapMarkerSC.sink;

  Stream<List<Marker>> get mapMarkerStream => _mapMarkerSC.stream;
  late double distancecorrectionFactor, googleDistance, duration = 0.0;
  late Leg currentTravelLeg;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    //fetch direction polylines from Google API
    super.initState();
    _sessionToken = uuid.v4();
    addMarker();
    getDirections();
  }

  getDirections() async {
    if (GOOGLE_API_INVOCATIONS > GOOGLE_API_INVOCATION_LIMIT) {
      return;
    }
    String request =
        '$directionBaseURL?origin=${carCurrentLocation.latitude},${carCurrentLocation.longitude}&destination=${pickupLocation.latitude},${pickupLocation.longitude}&mode=driving&transit_routing_preference=less_driving&sessiontoken=$_sessionToken&key=$googleAPiKey';
    var url = Uri.parse(request);

    dynamic response = await HTTP.get(context,url);
    if (response != null && response != null) {
      if (response.statusCode == 200) {
        DirectionModel directionModel =
            DirectionModel.fromJson(json.decode(response.body));
        List<PointLatLng> pointLatLng = [];

//RAGHU VT  , We can have  multiple routes available. use the first one currently

        currentTravelLeg = directionModel.routes[0].legs[0];
        for (var k = 0; k < currentTravelLeg.steps.length; k++) {
          duration = currentTravelLeg.duration.value.toDouble();
          googleDistance = currentTravelLeg.distance.value.toDouble();

          pointLatLng = polylinePoints
              .decodePolyline(currentTravelLeg.steps[k].polyline.points);
          for (var point in pointLatLng) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
        }

        addPolyLine(polylineCoordinates);
        distancecorrectionFactor = googleDistance /
            calculateDistance(
                carCurrentLocation.latitude,
                carCurrentLocation.longitude,
                pickupLocation.latitude,
                pickupLocation.longitude);

        waitingTimeDisplayCB(duration);

        GOOGLE_API_INVOCATIONS++;

        timer = Timer(
          Duration(minutes: GOOGLE_API_INNTERVAL_MINUTES),
          () {
            getDirections();
          },
        );
      } else {
        throw Exception('Failed to load predictions');
      }
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    carCurrentLocation = LatLng(
        (widget.liveTripData!.driverLocation!.latitude != null)
            ? widget.liveTripData!.driverLocation!.latitude
            : 14.063446041067092,
        (widget.liveTripData!.driverLocation!.longitude != null)
            ? widget.liveTripData!.driverLocation!.longitude
            : 77.345492878187);

    if (previousLocation.latitude != 0.0 &&
        previousLocation != carCurrentLocation && mapController!=null) {
      animateCar(
        previousLocation.latitude,
        previousLocation.longitude,
        carCurrentLocation.latitude,
        carCurrentLocation.longitude,
        mapMarkerSink,
        this,
        mapController!,
      );
    }

    final googleMap = StreamBuilder<List<Marker>>(
        stream: mapMarkerStream,
        builder: (context, snapshot) {
          return GoogleMap(
        //    mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              //innital position in map
              target: carCurrentLocation, //initial position
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
          polylineCoordinates != null && polylineCoordinates.isNotEmpty
              ? googleMap
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
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
    if (mounted) {
      setState(() {
        if (previousLocation != carCurrentLocation) {
          previousLocation = carCurrentLocation;
        }
      });
    }

  }

  addMarker() async {
    var pickupMarker = Marker(
      //add start location marker
      markerId: MarkerId(pickupLocation.toString()),
      position: pickupLocation, //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Pickup Location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen), //Icon for Marker
    );

    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/car-map.png', 70);

    carMarker = Marker(
        markerId: const MarkerId("Driver Location"),
        position: carCurrentLocation,
        infoWindow: const InfoWindow(
          //popup info
          title: 'Driver Location',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: const Offset(0.5, 0.5),
        flat: true,
        rotation: getBearing(pickupLocation, carCurrentLocation),
        draggable: false);

    if (driverStartingLocation == null) {
      driverStartingLocation = Marker(
        //add start location marker
        markerId: MarkerId(carCurrentLocation.toString()),
        position: carCurrentLocation, //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Driver Starting Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange), //Icon for Marker
      );
      markers.add(driverStartingLocation);
    }
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
    final double bearing = getBearing(pickupLocation, carCurrentLocation);

    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/car-map.png', 70);

    animationController = AnimationController(
      duration: const Duration(seconds: 5), //Animation duration of marker
      vsync: provider, //From the widget
    );

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController!)
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
            markerId: const MarkerId("Driver Location"),
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
    animationController!.forward();
   if(mounted){
     setState(() {
       if (previousLocation != carCurrentLocation) {
         previousLocation = carCurrentLocation;
       }
     });
   }
    updatePickupTime();
  }

  void updatePickupTime() {
    double alternateTime = alternateDurationFromGoogleLegs(
      carCurrentLocation.latitude,
      carCurrentLocation.longitude,
    );
    waitingTimeDisplayCB(alternateTime);
  }

  void waitingTimeDisplayCB(time) {
    int minutes = time ~/ 60;
    int seconds = (time % 60).toInt();
    if (minutes > 0) {
      widget.callback("$minutes Minutes");
    } else {
      widget.callback("$seconds Seconds");
    }
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

  @override
  void dispose() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
      GOOGLE_API_INVOCATIONS = 9999; //to Ensure we don't call this again
    }
    if (mapController != null) {
      mapController!.dispose();
    }
    if (animationController != null && animationController!.isAnimating) {
      animationController!.dispose();
    }

    super.dispose();
  }

//Find CLosest Location on Leg
  double alternateDurationFromGoogleLegs(latitude, longitude) {
    var min = 99999999.0;
    var index = 0;
    for (int i = 0; i < currentTravelLeg.steps.length; i++) {
      var step = currentTravelLeg.steps[i];
      var lat = step.startLocation.lat;
      var lng = step.startLocation.lng;
      var dist = calculateDistance(latitude, longitude, lat, lng);
      if (dist < min) {
        min = dist;
        index = i;
      }
    }

    double diffDistance = distancecorrectionFactor *
        calculateDistance(
            latitude,
            longitude,
            currentTravelLeg.steps[index].startLocation.lat,
            currentTravelLeg.steps[index].startLocation.lng);

    double dur = (duration / googleDistance) * diffDistance;
    for (int i = index; i < currentTravelLeg.steps.length; i++) {
      var step = currentTravelLeg.steps[i];
      dur += step.duration.value.toDouble();
    }

    return dur;
  }
}
