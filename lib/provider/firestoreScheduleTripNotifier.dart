import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../web_service/Constant.dart';

class firestoreScheduleTripNotifier extends ChangeNotifier {
  dynamic scheduleFailureSream = [];
  late SharedPreferences sharedPreferences;

  Future<void> listenToLiveUpdateStream() async {
    String liveUpdatecollectionName =
        'user/972a23cf-5119-4cfb-a247-ab04b9feb401/scheduled-trips';
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(liveUpdatecollectionName);
    try {
      DateTime now = new DateTime.now();
      final notificationStream = await collectionRef.snapshots();
      notificationStream.listen((result) {
        print("object$result");
        for (var res in result.docChanges) {
          var data = res.doc.data();

          scheduleFailureSream.add(data);
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint("ERROR - $e");
      return null;
    }
  }
}
