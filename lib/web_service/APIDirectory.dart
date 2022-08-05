import 'package:envi/web_service/ApiConstants.dart' as APICONSTANTS;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiConfig.dart' as APICONFIG;
import 'Constant.dart';

const scheme = 'http';
const host = 'localhost';
const port = '3300';
const mobileHost = '192.168.1.11';

const webBaseUrl = '$scheme://$host:$port';
const mobileBaseUrl = '$scheme://$mobileHost:$port';

const deployedLambdaUrl = "";

const qaUrl = 'https://qausernew.azurewebsites.net';

const productionUrl = 'https://envi-user-taxation-v2.azurewebsites.net';

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



searchPlace() {
  return Uri.parse('${getBaseURL()}/user/getGooglePlace');
}
