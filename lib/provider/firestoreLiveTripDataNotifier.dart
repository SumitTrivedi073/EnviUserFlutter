import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../appConfig/Profiledata.dart';
import '../utils/utility.dart';
import 'model/tripDataModel.dart';

class firestoreLiveTripDataNotifier extends ChangeNotifier {
  TripDataModel? liveTripData;

  Future<void> listenToLiveUpdateStream() async {

    String liveUpdatecollectionName =
        'user/${Profiledata().getusreid()}/running-trip';
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(liveUpdatecollectionName);
    try {
      final notificationStream =  collectionRef.snapshots();
      notificationStream.listen((result) {
        var count = 0;
        print("object");
        for (var res in result.docChanges) {
          dynamic data = res.doc.data();

          var dstat = data?["passengerTripMasterId"];
          print("trip data ${dstat}");

          FirebaseFirestore.instance
              .collection("trips")
              .doc("passengerTripMasterId:$dstat")
              .snapshots()
              .listen((event) {
            var jsonObj = event.data();

            var encodedJson = json.encode(jsonObj, toEncodable: myEncode);
            var jsonData = json.decode(encodedJson);
            print("tripdata========> ${event.data()}");
            if(jsonData!=null && jsonData.toString().isNotEmpty) {
              liveTripData = TripDataModel.fromJson(jsonData);
            } else {
              liveTripData = null;
            }
            notifyListeners();
          });
        }

      });
    } catch (e) {
      debugPrint("ERROR - $e");
      return null;
    }
  }
}
