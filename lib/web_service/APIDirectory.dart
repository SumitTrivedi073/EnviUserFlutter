import 'package:envi/web_service/ApiConstants.dart' as APICONSTANTS;
import 'package:flutter/foundation.dart';
import 'ApiConfig.dart' as APICONFIG;

const scheme = 'http';
const host = 'localhost';
const port = '3300';
const mobileHost = '192.168.1.8';

const webBaseUrl = '$scheme://$host:$port';
const mobileBaseUrl = '$scheme://$mobileHost:$port';

const deployedLambdaUrl = "";

const qaUrl = 'https://qausernew.azurewebsites.net/';

const productionUrl = 'https://envi-user-taxation-v2.azurewebsites.net/';
const directionBaseURL = 'https://maps.googleapis.com/maps/api/directions/json';

getBaseURL() {
  String baseUrl = deployedLambdaUrl;
  String apiType = APICONFIG.releaseType;
  if (apiType == APICONSTANTS.localhost) {
    if (kIsWeb) {
      print("1");
      baseUrl = webBaseUrl;
    } else {

      print("2");
      baseUrl = mobileBaseUrl;
    }
  } else if (apiType == APICONSTANTS.production) {
    print("3");
    baseUrl = productionUrl;
  } else if (apiType == APICONSTANTS.qa) {
    print("4");
    baseUrl = qaUrl;
  }
  return baseUrl;
}
userLogin() {
  return Uri.parse('${getBaseURL()}/login/userLogin');
}
searchPlace() {
  return Uri.parse('${getBaseURL()}/user/getGooglePlace');
}
getfetchLandingPageSettings(){

  return Uri.parse('${getBaseURL()}/login/fetchLandingPageSettings');
}
getUserTripHistory(String userid, int pagecount, int limit){
  print(Uri.parse('${getBaseURL()}/userTrip/getUserTripHistory/$userid/$pagecount/$limit'));
  return Uri.parse('${getBaseURL()}/userTrip/getUserTripHistory/$userid/$pagecount/$limit');
}
GetAllFavouriteAddressdata(String userid){
  return Uri.parse('${getBaseURL()}/user/favouriteAddress/getAll/$userid');
}
searchDriver() {
  return Uri.parse('${getBaseURL()}/userTrip/searchDrivers');
}
startTrip() {
  return Uri.parse('${getBaseURL()}/userTrip/startUserTrip');
}
cancelTrip() {
  return Uri.parse('${getBaseURL()}/userTrip/cancelUserTrip');
}
SosApi() {
  return Uri.parse('${getBaseURL()}/user/sos');
}

EditFavouriteAddressdata(){
  return Uri.parse('${getBaseURL()}/user/favouriteAddress/update');
}
AddFavouriteAddressdata(){
  return Uri.parse('${getBaseURL()}/user/favouriteAddress/add');
}
DeleteFavouriteAddressdata(){
  return Uri.parse('${getBaseURL()}/user/favouriteAddress/delete');
}

updatePaymentMode(){
  return Uri.parse('${getBaseURL()}/userTrip/updatePaymentMode');
}