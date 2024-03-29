class AppConfig {
  AppConfig._privateConstructor();

  static final AppConfig _instance = AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }
  static int minAndroidVersion = 0;
  static int miniOSVersion = 0;
  static String androidAppUrl = "";
  static String iosAppUrl = "";
  static int advance_booking_time_limit = 0;
  static int driver_assignment_time_limit = 0;
  static bool isScheduleFeatureEnabled = true;
  static int scheduleFreeDriverDistance = 0;
  static int scheduleAllottedDriverDistance = 0;
  static String paymentOptions = "";
  static String defaultPaymentMode = "";
  static bool isCancellationFeeApplicable = false;
  static int cancellationFee = 0;
  static int googleDirectionDriverIntervalInMin = 0;
  static int googleDirectionDriverIntervalMaxTrialCount = 0;
  static int googleDirectionWFDriverIntervalInMin = 10;
  static int googleDirectionWFDriverIntervalMaxTrialCount = 3;
  static bool isNormalBookingFeatureEnabled = true;
  static int maxAllowedDistance = 150;

  static void setminAndroidVersion(int val) {
    minAndroidVersion = val;
  }

  int getminAndroidVersion() {
    return minAndroidVersion;
  }

  static setminiOSVersion(int val) {
    miniOSVersion = val;
  }

  int getminiOSVersion() {
    return miniOSVersion;
  }

  static setandroidAppUrl(String val) {
    androidAppUrl = val;
  }

  String getandroidAppUrl() {
    return androidAppUrl;
  }

  static setiosAppUrl(String val) {
    iosAppUrl = val;
  }

  String getiosAppUrl() {
    return iosAppUrl;
  }

  static setadvance_booking_time_limit(int val) {
    advance_booking_time_limit = val;
  }

  int getadvance_booking_time_limit() {
    return advance_booking_time_limit;
  }

  static setdriver_assignment_time_limit(int val) {
    driver_assignment_time_limit = val;
  }

  int getdriver_assignment_time_limit() {
    return driver_assignment_time_limit;
  }

  static setisScheduleFeatureEnabled(bool val) {
    isScheduleFeatureEnabled = val;
  }

  bool getisScheduleFeatureEnabled() {
    return isScheduleFeatureEnabled;
  }

  static setscheduleFreeDriverDistance(int val) {
    scheduleFreeDriverDistance = val;
  }

  int getscheduleFreeDriverDistance() {
    return scheduleFreeDriverDistance;
  }

  static setpaymentOptions(String val) {
    paymentOptions = val;
  }

  String getpaymentOptions() {
    return paymentOptions;
  }

  static setdefaultPaymentMode(String val) {
    defaultPaymentMode = val;
  }

  String getdefaultPaymentMode() {
    return defaultPaymentMode;
  }

  static setscheduleAllottedDriverDistance(int val) {
    scheduleAllottedDriverDistance = val;
  }

  int getscheduleAllottedDriverDistance() {
    return scheduleAllottedDriverDistance;
  }

  static setisCancellationFeeApplicable(bool val) {
    isCancellationFeeApplicable = val;
  }

  bool getisCancellationFeeApplicable() {
    return isCancellationFeeApplicable;
  }

  static setcancellationFee(int val) {
    cancellationFee = val;
  }

  int getcancellationFee() {
    return cancellationFee;
  }
  static setgoogleDirectionDriverIntervalInMin(int val){googleDirectionDriverIntervalInMin = val;}
  int getgoogleDirectionDriverIntervalInMin(){
    return googleDirectionDriverIntervalInMin;
  }

  static setgoogleDirectionDriverIntervalMaxTrialCount(int val){googleDirectionDriverIntervalMaxTrialCount = val;}
  int getgoogleDirectionDriverIntervalMaxTrialCount(){
    return googleDirectionDriverIntervalMaxTrialCount;
  }
  static setisNormalBookingFeatureEnabled(bool val) {
    isNormalBookingFeatureEnabled = val;
  }

  bool getisNormalBookingFeatureEnabled() {
    return isNormalBookingFeatureEnabled;
  }

  static setmaxAllowedDistance(int val) {
    maxAllowedDistance = val;
  }

  int getmaxAllowedDistance() {
    return maxAllowedDistance;
  }
}
