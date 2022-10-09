class AppConfig {

  AppConfig._privateConstructor();

  static final AppConfig _instance = AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }
  static int minAndroidVersion = 0;
  static int miniOSVersion = 0;
  static String androidAppUrl = "";
  static String iosAppUrl= "";
  static int advance_booking_time_limit = 0;
  static int driver_assignment_time_limit = 0;
  static bool isScheduleFeatureEnabled = false;
  static int scheduleFreeDriverDistance = 0;
  static int scheduleAllottedDriverDistance = 0;
  static String paymentOptions = "";
  static String defaultPaymentMode = "";


  static void setminAndroidVersion(int val){minAndroidVersion = val;}
  int getminAndroidVersion(){
    return minAndroidVersion;
  }


  static setminiOSVersion(int val){miniOSVersion = val;}
  int getminiOSVersion(){
    return miniOSVersion;
  }
  static setandroidAppUrl(String val){androidAppUrl = val;}
  String getandroidAppUrl(){
    return androidAppUrl;
  }
  static setiosAppUrl(String val){iosAppUrl = val;}
  String getiosAppUrl(){
    return iosAppUrl;
  }
  static setadvance_booking_time_limit(int val){advance_booking_time_limit = val;}
  int getadvance_booking_time_limit(){
    return advance_booking_time_limit;
  }
  static setdriver_assignment_time_limit(int val){driver_assignment_time_limit = val;}
  int getdriver_assignment_time_limit(){
    return driver_assignment_time_limit;
  }
  static setisScheduleFeatureEnabled(bool val){isScheduleFeatureEnabled = val;}
  bool getisScheduleFeatureEnabled(){
    return isScheduleFeatureEnabled;
  }

  static setscheduleFreeDriverDistance(int val){scheduleFreeDriverDistance = val;}
  int getscheduleFreeDriverDistance(){
    return scheduleFreeDriverDistance;
  }
  static setpaymentOptions(String val){paymentOptions = val;}
  String getpaymentOptions(){
    return paymentOptions;
  }
  static setdefaultPaymentMode(String val){defaultPaymentMode = val;}
  String getdefaultPaymentMode(){
    return defaultPaymentMode;
  }
  static setscheduleAllottedDriverDistance(int val){scheduleAllottedDriverDistance = val;}
  int getscheduleAllottedDriverDistance(){
    return scheduleAllottedDriverDistance;
  }

}