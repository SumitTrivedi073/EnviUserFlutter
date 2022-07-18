import 'dart:convert';
// import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../web_service/HTTP.dart' as HTTP;
import 'APIDirectory.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ApiCollection {

  static Future<dynamic> logoutDriverById(id) async {
    dynamic res = await HTTP.post(logoutDriver(id), null);
    var obj;
    obj = {
      'status': res.statusCode.toString(),
      'msg': jsonDecode(res.body)['message'].toString(),
    };
    return res;
  }

  static Future<dynamic> DeleteAssignDriver(id) async {
    dynamic res = await HTTP.delete(deleteAssignDriver(id));
    return res;
  }





  static Future<dynamic> ShedualTripconfirm(id, status, reason) async {
    Map data = {"_id": id, "status": status, "reason": reason};
    var jsonData = null;

    dynamic res = await HTTP.post(schedualtripStatus(), data);
    return res;
  }



  static Future<dynamic> scheduledTrips_assignDriver(
      id, driverID, status) async {
    Map data = {"_id": id, "driverId": driverID, "driver_status": status};
    dynamic res = await HTTP.post(scheduledTrips_assignDriverurl(), data);
    return res;
  }

  static Future<dynamic> scheduledTrips_reassignDriver(
      id, driverID, driver_status) async {
    Map data = {
      "_id": id,
      "driverId": driverID,
      "driver_status": driver_status
    };
    dynamic res = await HTTP.post(scheduledTrips_reassignDriverurl(), data);
    return res;
  }

  static Future<dynamic> scheduledTripCancel(id, reason) async {
    Map data = {"_id": id, "reason": reason};
    dynamic res = await HTTP.post(scheduledTripCancelUrl(), data);
    return res;
  }

  static Future<dynamic> getReportTypes() async {
    dynamic res = await HTTP.get(adminReportTypes());
    return res;
  }

  static Future<dynamic> retriggerNotifyDriver(tripObjId) async {
    dynamic res = await HTTP.get(retriggerNotifyDriver(tripObjId));
    return res;
  }

  static Future<dynamic> addDriverdata(driverObject, imageObject) async {
    try {
      var response;
      var url = addDriver();
      if (imageObject != null) {
        var files = [
          http.MultipartFile.fromBytes(
              "driverImage", imageObject['driverImageBufferData'],
              filename: imageObject['driverImageFileName']),
          http.MultipartFile.fromBytes(
              "driverDocument", imageObject['driverDocumentBufferData'],
              filename: imageObject['driverDocumentFileName'])
        ];
        response = await HTTP.postDataWithMutipleFiles(
            url, driverObject, files, 'driverObject');
        var postResponse = await response.stream.bytesToString();
        var responseBody = json.decode(postResponse);
        return responseBody;
      } else {
        var error = "Parameters cannot be empty";
        throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<dynamic> updateDriverdata(driverObject, files) async {
    try {
      var response;
      var url = editDriver();
      if (files != null && files.length > 0 && files[0] != null) {
        response = await HTTP.postDataWithMutipleFiles(
            url, driverObject, files, 'driverObject');

        var postResponse = await response.stream.bytesToString();
        var responseBody = json.decode(postResponse);
        return responseBody;
      } else {
        response = await HTTP.post(url, driverObject);
        return response;
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<dynamic> addCardata(carObject, bufferData, fileName) async {
    try {
      var response;
      var url = addCar();
      if (bufferData != null) {
        response = await HTTP.postToAcceptMultipartRequest(
            url, carObject, bufferData, fileName, "carObject");
        var postResponse = await response.stream.bytesToString();
        var responseBody = json.decode(postResponse);
        return responseBody;
      } else {
        var error = "Parameters cannot be empty";
        throw error;
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<dynamic> updateCardata(carObject, bufferData, fileName) async {
    try {
      var response;
      var url = editCar();
      if (bufferData != null && fileName != null) {
        response = await HTTP.postToAcceptMultipartRequest(
            url, carObject, bufferData, fileName, "carObject");
        var postResponse = await response.stream.bytesToString();

        var responseBody = json.decode(postResponse);

        return responseBody;
      } else {
        response = await HTTP.post(url, carObject);
        var responseBody = json.decode(response.body);
        return responseBody;
      }
    } catch (error) {
      throw error;
    }
  }

  static Future<dynamic> getDriverlistbystatus(String query) async {
    print(getdriverlistbystatus(query));
    dynamic res = await HTTP.get(getdriverlistbystatus(query));
    return res;
    // if (res.statusCode == 200) {
    //   print(" Driver data ${jsonDecode(res.body)['activity']}");
    //   print(jsonDecode(res.body)['content']);
    //   List<dynamic> body = jsonDecode(res.body)['content'];
    //
    //   List<DriverStatus> posts = body
    //       .map(
    //         (dynamic item) => DriverStatus.fromJson(item),
    //       )
    //       .toList();
    //   return posts;
    // } else {
    //   throw "Unable to retrieve posts.";
    // }
  }

  static Future<dynamic> GetAppConfig() async {
    dynamic res = await HTTP.get(getAppConfig());
    return res;
  }

  static Future<dynamic> UpdateAppConfig(data) async {
    dynamic res = await HTTP.post(updateAppConfig(), data);
    return res;
  }

  static Future<dynamic> GetLandingConfig() async {
    dynamic res = await HTTP.get(getLandingConfig());
    return res;
  }

  static Future<dynamic> UpdateLandingConfig(data) async {
    dynamic res = await HTTP.post(updateLandingConfig(), data);
    return res;
  }





  static Future<dynamic> GetfetchMissInfo(num) async {
    dynamic res = await HTTP.getwithoutHeader(getMissTripInfomMicroApi(num));

    return res;
  }

  static Future<dynamic> fetchDriverActivity(num) async {
    dynamic res = await HTTP.get(getDriverActivity(num));

    return res;
  }

  static Future<dynamic> editPaymentMode(passengerTripMasterId, paymentMode,
      remarks, changesdata, toll, distance, priceInclusiveOfTax, paymentStatus,manualVerificationStatus) async {

    Map data = {
      "passengerTripMasterId": passengerTripMasterId,
      "paymentMode": paymentMode,
      "remarks": remarks,
      "toll": double.parse(toll),
      "distance": double.parse(distance),
      "priceInclusiveOfTax": double.parse(priceInclusiveOfTax),
      "paymentStatus": paymentStatus,
      "manualVerificationStatus":manualVerificationStatus
    };
    //print('${passengerTripMasterId},${paymentMode},${remarks},${changesdata},${toll},${distance},${priceInclusiveOfTax},${paymentStatus}');
    print(data);
    dynamic res = await HTTP.post(editPaymentInfo(), data);
    print(res.body);
    return res;
  }
}
