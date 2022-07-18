/*
 * This file has all the rest urls for http request
 *  @author - Ruban Moses
 */
/*
 * local host settings
 */

import 'package:envi/web_service/ApiConstants.dart' as APICONSTANTS;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiConfig.dart' as APICONFIG;
import 'Constant.dart';

const scheme = 'http';
const host = 'localhost';
const port = '3300';
// const mobileHost = '10.0.2.2';
const mobileHost = '192.168.1.11';

const webBaseUrl = '$scheme://$host:$port';
const mobileBaseUrl = '$scheme://$mobileHost:$port';

/*
 * Dev host settings
 */
const deployedLambdaUrl = "";

/*
 * Prod host settings
 */
// const qaUrl = "https://qa-envi-admin-backend-app-service.azurewebsites.net";
const qaUrl = 'https://qa-admin-2022.azurewebsites.net';

/*
* Stage host settings
*/
// const productionUrl =
//     "https://envi-admin-backend-app-service.azurewebsites.net";
const productionUrl = 'https://admin22.azurewebsites.net';

getBaseURL() {
  String baseUrl = deployedLambdaUrl;
  String apiType = APICONFIG.releaseType;
  if (apiType == APICONSTANTS.localhost) {
    if (kIsWeb) {
      baseUrl = webBaseUrl;
    } else {
      baseUrl = mobileBaseUrl;
    }
  } else if (apiType == APICONSTANTS.production) {
    baseUrl = productionUrl;
  } else if (apiType == APICONSTANTS.qa) {
    baseUrl = qaUrl;
  }
  return baseUrl;
}

userLogin() {
  return Uri.parse('${getBaseURL()}/login/adminLogin');
}

forgotPasswordAPI() {
  return Uri.parse('${getBaseURL()}/login/resetPassword');
}

changePassword() {
  return Uri.parse('${getBaseURL()}/login/changePassword');
}

getDriverStruckList() {
  return Uri.parse('${getBaseURL()}/developer/stuckDrivers');
}

releaseDriverAPI() {
  return Uri.parse('${getBaseURL()}/developer/updateDriverStatus');
}

getLocationMismatchList() {
  return Uri.parse('${getBaseURL()}/developer/vehiclesWithLocationAnomaly');
}

getdriversearch(String searchtext, int limit) {
  return Uri.parse(
      '${getBaseURL()}/trip/getDriverList?keyword=$searchtext&limit=$limit');
}

getvehiclesearch(String searchtext, int limit) {
  return Uri.parse(
      '${getBaseURL()}/trip/getVehicleList?keyword=$searchtext&limit=$limit&page=1&trim=true');
}

getVehicleData(String searchtext, int page) {
  return Uri.parse(
      '${getBaseURL()}/trip/getVehicleList?keyword=$searchtext&limit=20&page=$page&trim=false');
}

updateVehicleIOTSettings() {
  return Uri.parse('${getBaseURL()}/vehicles/updateIOTSettings');
}

addManualTrip() {
  return Uri.parse('${getBaseURL()}/trip/addManualTrip');
}

getDashboardTripList() {
  return Uri.parse('${getBaseURL()}/trip');
}

getAssignVehicleList(String searchtext, int pagecount, int limit) {
  dynamic searchParam = searchtext != null && searchtext != "null"
      ? '?searchKey=$searchtext'
      : '';
  return Uri.parse(
      '${getBaseURL()}/driver/getAssignedDrivers2/$pagecount/$limit${searchParam}');
}

logoutDriver(id) {
  print("${getBaseURL()}/driver/logoutDriver/$id");
  return Uri.parse('${getBaseURL()}/driver/logoutDriver/$id');
}

deleteAssignDriver(id) {
  print("${getBaseURL()}/driver/unassignDriver/$id");
  return Uri.parse('${getBaseURL()}/driver/unassignDriver/$id');
}

deleteDriver(id) {
  print("${getBaseURL()}/driver/deleteDriver/$id");
  return Uri.parse('${getBaseURL()}/driver/deleteDriver/$id');
}

getUnassignedDrivers() {
  return Uri.parse('${getBaseURL()}/driver/getUnassignedDrivers');
}

getUnassignedVehicles() {
  return Uri.parse('${getBaseURL()}/vehicle/getUnassignedVehicles');
}

addAssignVehicle() {
  return Uri.parse('${getBaseURL()}/vehicle/assignVehicle');
}

getDriverList(String searchtext, int pagecount, int limit) {
  dynamic searchParam = searchtext != null ? '?searchKey=$searchtext' : '';
  return Uri.parse(
      '${getBaseURL()}/driver/getAllDrivers/$pagecount/$limit${searchParam}');
}

getSchedualList() {
  return Uri.parse('${getBaseURL()}/scheduledTrips/list');
}

schedualtripStatus() {
  return Uri.parse(
      '${getBaseURL()}/scheduledTrips/changeScheduleBookingStatus');
}

getListOfFreeDrivers(String TripID) {
  return Uri.parse(
      '${getBaseURL()}/scheduledTrips/getListOfDrivers?tripObjId=$TripID');
}

scheduledTrips_assignDriverurl() {
  return Uri.parse('${getBaseURL()}/scheduledTrips/assignDriver');
}

scheduledTripCancelUrl() {
  return Uri.parse('${getBaseURL()}/scheduledTrips/cancelScheduleTrip');
}

scheduledTrips_reassignDriverurl() {
  return Uri.parse('${getBaseURL()}/scheduledTrips/reassignNewDriver');
}

adminReportTypes() {
  return Uri.parse('${getBaseURL()}/reports/reportsList');
}

retriggerNotifyDriver(String tripObjId) {
  return Uri.parse(
      '${getBaseURL()}/scheduledTrips/retriggerNotifyDriver?tripObjId=$tripObjId');
}

Future<Uri> getAdminReportsAPI(queryParams) async {
  print("Excel download $queryParams");
  late SharedPreferences sharedPreferences;

  sharedPreferences = await SharedPreferences.getInstance();

  var token = sharedPreferences.getString(LoginToken);
  return Uri.parse(
      '${getBaseURL()}/reports/adminReports?token=$token&$queryParams');
}

addDriver() {
  return Uri.parse('${getBaseURL()}/driver/createDriverWithDocuments');
}

editDriver() {
  return Uri.parse('${getBaseURL()}/driver/editDriverWithDocuments');
}

addCar() {
  return Uri.parse('${getBaseURL()}/vehicle/postVehicle');
}

editCar() {
  return Uri.parse('${getBaseURL()}/vehicle/editVehicle');
}

getMissedTripList() {
  return Uri.parse('${getBaseURL()}/trip/missedTrips');
}

getdriverlistbystatus(String status) {

  return Uri.parse('${getBaseURL()}/driver/getDriversByStatus/$status');
}

getAppConfig() {
  return Uri.parse('${getBaseURL()}/admin/getAppConfig');
}

updateAppConfig() {
  return Uri.parse('${getBaseURL()}/admin/updateAppConfig');
}

getPromotionList() {
  return Uri.parse('${getBaseURL()}/admin/getPromotions');
}

getLandingConfig() {
  return Uri.parse('${getBaseURL()}/admin/getLandingPageConfig');
}

updateLandingConfig() {
  return Uri.parse('${getBaseURL()}/admin/updateLandingPage');
}

getVehicleInfofromMicroApi(String num,String fdate,String ldate) {
  return Uri.parse('https://api-beta.malbork.in/api-vmt/fetchVehicleInfo?num=$num&from_date=$fdate&to_date=$ldate');
}


getDriverInfomMicroApi(String num,String fdate,String ldate) {
  return Uri.parse('https://api-beta.malbork.in/api-vmt/fetchDriverInfo?driverId=$num&from_date=$fdate&to_date=$ldate');
}

getIoDeviceInfomMicroApi(String num,String fdate,String ldate) {
  return Uri.parse('https://api-beta.malbork.in/api-vmt/fetchFromIotDeviceLogs?num=$num&from_date=$fdate&to_date=$ldate');
}
getMissTripInfomMicroApi(String num) {
  return Uri.parse('https://api-beta.malbork.in/api-vmt/fetchDriversLocWrtMissedTrips?timeRange=$num');
}
getDriverActivity(String driverId) {
  return Uri.parse('${getBaseURL()}/driver/getDriverActivity/$driverId');
}
editPaymentInfo() {
  return Uri.parse('${getBaseURL()}/trip/editPaymentInfo');
}