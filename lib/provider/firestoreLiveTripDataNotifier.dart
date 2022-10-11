import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utility.dart';
import 'model/tripDataModel.dart';

class firestoreLiveTripDataNotifier extends ChangeNotifier {
  TripDataModel? liveTripData;
  String passengerTripMasterId = '';
  late SharedPreferences sharedPreferences;

  Future<void> listenToLiveUpdateStream() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String liveUpdatecollectionName =
        'user/${sharedPreferences.getString(LoginID)}/running-trip';
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(liveUpdatecollectionName);
    try {
      final notificationStream = collectionRef.snapshots();
      notificationStream.listen((result) {
        var count = 0;
        print("FIREBASETEST object");
        for (var res in result.docChanges) {
          dynamic data = res.doc.data();

          var passengerTripMasterId = data?["passengerTripMasterId"];
          print("FIREBASETEST ptm${passengerTripMasterId}");

          FirebaseFirestore.instance
              .collection("trips")
              .doc("passengerTripMasterId:$passengerTripMasterId")
              .snapshots()
              .listen((event) {
            dynamic data = res.doc.data();

            var jsonObj = event.data();

            var encodedJson = json.encode(jsonObj, toEncodable: myEncode);
            var jsonData = json.decode(encodedJson);
            // print("FIREBASETEST trripdata========> ${event.data()}");
            if (jsonData != null && jsonData.toString().isNotEmpty) {
              liveTripData = TripDataModel.fromJson(jsonData);
              print("FIREBASETEST11 liveTripData ${liveTripData}");
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
