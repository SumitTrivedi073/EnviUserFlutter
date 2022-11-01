
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
  String googleAPiKey = GoogleApiKey;
  Set<Marker> markers = Set(); //markers for google map
  late LatLng pickupLocation = LatLng(widget.fromAddress!.latLng.latitude, widget.fromAddress!.latLng.longitude);
  late  LatLng destinationLocation =  LatLng(widget.toAddress!.latLng.latitude, widget.toAddress!.latLng.longitude);



  @override
  void initState() {
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


    super.initState();
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
        mapType: MapType.normal,
        rotateGesturesEnabled: false,
        zoomControlsEnabled: true,
        onMapCreated: (controller) { //method called when map is created
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
