import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envi/appConfig/Profiledata.dart';
import 'package:envi/sidemenu/upcomingride/model/ScheduleTripModel.dart';
import 'package:flutter/foundation.dart';

import '../utils/utility.dart';
import '../web_service/Constant.dart';
import 'model/scheduleTrip.dart';

class firestoreScheduleTripNotifier extends ChangeNotifier {
  dynamic scheduleFailureSream = [];
  ScheduleTrip? scheduleTrip;
  Future<void> listenToLiveUpdateStream() async {
    String liveUpdatecollectionName =
        'user/${Profiledata().getusreid()}/scheduled-trips';
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(liveUpdatecollectionName);
    try {
      DateTime now = new DateTime.now();
      final notificationStream = await collectionRef.snapshots();
      notificationStream.listen((result) {
        print("object$result");
        for (var res in result.docChanges) {
          var data = res.doc.data();

          var encodedJson = json.encode(data, toEncodable: myEncode);
          var jsonData = json.decode(encodedJson);
          print("scheduleTripModel========> ${res.doc.data()}");
          if(jsonData!=null && jsonData.toString().isNotEmpty) {
            scheduleTrip = ScheduleTrip.fromJson(jsonData);
          } else {
            scheduleTrip = null;
          }
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint("ERROR - $e");
      return null;
    }
  }
}
