import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constant.dart';

Response? AccessPermissionHandler(response) {
  if (response.statusCode == 401) {
    Fluttertoast.showToast(
        msg: 'ACCESS DENIED',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 30,
        backgroundColor: Color.fromARGB(255, 163, 5, 5),
        textColor: Colors.white,
        fontSize: 16.0,
        webBgColor: "#b80419",
        webPosition: ToastGravity.CENTER,
        webShowClose: true);

    return null;
  } else {
    return response;
  }
}

Future<Map<String, String>> setRequestHeaders([additionalHeaders]) async {
  const contentType = 'application/json';
  Map<String, String> headers = {'Content-Type': contentType};

  var sharedPreferences = await SharedPreferences.getInstance();

  dynamic token = sharedPreferences.getString(LoginToken);
  print("token$token");
  dynamic extra = additionalHeaders != null ? additionalHeaders : {};

  return headers = {
    'Content-Type': contentType,
    'x-access-token': token != null ? token : '',
    ...extra
  };
}

Future<Object?> get(url, [headers]) async {
  try {
    Map<String, String> requestHeaders = await setRequestHeaders(headers);
    var response = await http.get(url, headers: requestHeaders);
    return AccessPermissionHandler(response);
  } catch (error) {
    print('Something went wrong in HTTP Get $error');

    throw error;
  }
}

Future<Object?> post(url, data, [headers]) async {
  try {
    final encodedData = data != null ? jsonEncode(data) : null;
    Map<String, String> requestHeaders = await setRequestHeaders(headers);

    var response = await http.post(
      url,
      headers: requestHeaders,
      body: encodedData,
    );
    return AccessPermissionHandler(response);
  } catch (error) {
    throw error;
  }
}

Future<Object?> put(url, data, [headers]) async {
  try {
    final encodedData = jsonEncode(data);
    Map<String, String> requestHeaders = await setRequestHeaders(headers);
    var response =
        await http.put(url, body: encodedData, headers: requestHeaders);
    return AccessPermissionHandler(response);
  } catch (error) {
    throw error;
  }
}

Future<Object?> delete(url, [headers]) async {
  try {
    Map<String, String> requestHeaders = await setRequestHeaders(headers);
    print('response in http delete before ');

    var response = await http.delete(url, headers: requestHeaders);
    print('response in http delete after ');
    return AccessPermissionHandler(response);
  } catch (error) {
    throw error;
  }
}

Future<Object> postToAcceptMultipartRequest(
    url, data, bufferData, fileName, fieldName,
    [headers]) async {
  try {
    Map<String, String> requestHeaders = await setRequestHeaders(headers);
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(requestHeaders);
    request.files.add(http.MultipartFile.fromBytes(fieldName, bufferData,
        filename: fileName));
    request.fields[fieldName] = json.encode(data);
    var response = await request.send();
    return response;
  } catch (error) {
    throw error;
  }
}

Future<Object> postDataWithMutipleFiles(url, data, files, fieldName,
    [headers]) async {
  print('inside postDataWithMutipleFiles ');
  try {
    Map<String, String> requestHeaders = await setRequestHeaders(headers);
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(requestHeaders);
    for (int i = 0; i < files.length; i++) {
      request.files.add(files[i]);
    }
    request.fields[fieldName] = json.encode(data);
    // request.fields[fieldName] = data;

    var response = await request.send();
    return response;
  } catch (error) {
    print('Error in postDataWithMutipleFiles $error');
    throw error;
  }
}

Future<Object?> getwithoutHeader(url) async {
  try {
    const contentType = 'application/json';
    Map<String, String> headerstemp = {'Access-Control-Allow-Origin': "*"};
    var response = await http.get(url, headers: headerstemp);
    return AccessPermissionHandler(response);
  } catch (error) {
    print('Something went wrong in HTTP Get $error');

    throw error;
  }
}
