import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../utils/utility.dart';
import 'model/tripDataModel.dart';


class firestoreScheduleTripNotifier extends ChangeNotifier {
  late TripDataModel liveTripData;

  Future<void> listenToLiveUpdateStream() async {
    String liveUpdatecollectionName = 'user/1c7b86c2-a9f7-4037-8b46-c8059deac779/scheduled-trips';
    final CollectionReference collectionRef =
    FirebaseFirestore.instance.collection(liveUpdatecollectionName);
    try {
      final notificationStream = await collectionRef.snapshots();
      notificationStream.listen((result) {
        var count = 0;
        print("object$result");
        for (var res in result.docChanges) {
          dynamic data = res.doc.data();



        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint("ERROR - $e");
      return null;
    }
  }
}
