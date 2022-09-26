import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utility.dart';
import '../web_service/Constant.dart';
import 'model/tripDataModel.dart';


class firestoreScheduleTripNotifier extends ChangeNotifier {

  dynamic scheduleFailureSream = [];
  late SharedPreferences sharedPreferences;

  Future<void> listenToLiveUpdateStream() async {
    sharedPreferences = SharedPreferences.getInstance() as SharedPreferences;
    String liveUpdatecollectionName =
        'user/${sharedPreferences.getString(LoginID)}/scheduled-trips';
    final CollectionReference collectionRef =
    FirebaseFirestore.instance.collection(liveUpdatecollectionName);
    try {
      DateTime now = new DateTime.now();
      final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
          now.millisecondsSinceEpoch - 15 * 60000); // 15min:  //(5.3*3600000)

      final notificationStream = await collectionRef.snapshots();
      notificationStream.listen((result) {
        var count = 0;
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
