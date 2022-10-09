class LandingPageConfig {

  LandingPageConfig._privateConstructor();

  static final LandingPageConfig _instance = LandingPageConfig._privateConstructor();

  factory LandingPageConfig() {
    return _instance;
  }
  static bool showInfoPopup = false;
  static String infoPopupType = "";
  static int autoExpiryDuration = 0;
  static String infoPopupFrequency= "";
  static String infoPopupTitle = "";
  static String infoPopupDescription = "";
  static String infoPopupImgagedUrl = "";
  static String infoPopupBackGroundColorCode = "";
  static bool isInfoPopUpTransparent = false;
  static bool isInfoPopUpFullScreen = false;
  // static String landingPageUrl = "";
  // static bool showIntroScreen = false;
  // static String serviceStartTime = "";
  // static String serviceEndTime = "";
  // static String displayText = "";
  // static String displayText_1= "";
  // static String displayText_2 = "";
  static bool enableReferAndWin = false;
  static String tariffURL = "";
  //static String userInfoSpaceURL = "";
  static String infoPopupId = "";
  static String customerCare = "";
static bool isOnMaintainance = false;
static String maintainanceInfoTouser = "";
  static void setshowInfoPopup(bool val){showInfoPopup = val;}
  bool getshowInfoPopup(){
    return showInfoPopup;
  }


  static setinfoPopupType(String val){infoPopupType = val;}
  String getinfoPopupType(){
    return infoPopupType;
  }
  static setautoExpiryDuration(int val){autoExpiryDuration = val;}
  int getautoExpiryDuration(){
    return autoExpiryDuration;
  }
  static setinfoPopupFrequency(String val){infoPopupFrequency = val;}
  String getinfoPopupFrequency(){
    return infoPopupFrequency;
  }
  static setinfoPopupTitle(String val){infoPopupTitle = val;}
  String getinfoPopupTitle(){
    return infoPopupTitle;
  }
  static setinfoPopupDescription(String val){infoPopupDescription = val;}
  String getinfoPopupDescription(){
    return infoPopupDescription;
  }
  static setinfoPopupImgagedUrl(String val){infoPopupImgagedUrl = val;}
  String getinfoPopupImgagedUrl(){
    return infoPopupImgagedUrl;
  }

  static setinfoPopupBackGroundColorCode(String val){infoPopupBackGroundColorCode = val;}
  String getinfoPopupBackGroundColorCode(){
    return infoPopupBackGroundColorCode;
  }
  static setisInfoPopUpTransparent(bool val){isInfoPopUpTransparent = val;}
  bool getisInfoPopUpTransparent(){
    return isInfoPopUpTransparent;
  }
  static setisInfoPopUpFullScreen(bool val){isInfoPopUpFullScreen = val;}
  bool getisInfoPopUpFullScreen(){
    return isInfoPopUpFullScreen;
  }
  // static setlandingPageUrl(String val){landingPageUrl = val;}
  // String getlandingPageUrl(){
  //   return landingPageUrl;
  // }
  // static setshowIntroScreen(bool val){showIntroScreen = val;}
  // bool getshowIntroScreen(){
  //   return showIntroScreen;
  // }
  // static setserviceStartTime(String val){serviceStartTime = val;}
  // String getserviceStartTime(){
  //   return serviceStartTime;
  // }
  // static setserviceEndTime(String val){serviceEndTime = val;}
  // String getserviceEndTime(){
  //   return serviceEndTime;
  // }
  // static setdisplayText(String val){displayText = val;}
  // String getdisplayText(){
  //   return displayText;
  // }
  // static setdisplayText_1(String val){displayText_1 = val;}
  // String getdisplayText_1(){
  //   return displayText_1;
  // }
  // static setdisplayText_2(String val){displayText_2 = val;}
  // String getdisplayText_2(){
  //   return displayText_2;
  // }
  static setenableReferAndWin(bool val){enableReferAndWin = val;}
  bool getenableReferAndWin(){
    return enableReferAndWin;
  }
  static settariffURL(String val){tariffURL = val;}
  String gettariffURL(){
    return tariffURL;
  }
  static setisOnMaintainance(bool val){isOnMaintainance = val;}
  bool getisOnMaintainance(){
    return isOnMaintainance;
  }
  static setmaintainanceInfoTouser(String val){maintainanceInfoTouser = val;}
  String getmaintainanceInfoTouser(){
    return maintainanceInfoTouser;
  }
  static setinfoPopupId(String val){infoPopupId = val;}
  String getinfoPopupId(){
    return infoPopupId;
  }
  static setcustomerCare(String val){customerCare = val;}
  String getcustomerCare(){
    return customerCare;
  }

}