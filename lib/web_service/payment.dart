import 'package:envi/payment/models/payment_type.dart';
import 'APIDirectory.dart';
import '../../../../web_service/HTTP.dart' as HTTP;
import 'dart:convert' as convert;


class PaymentService {
  Future<void> updatePayment({required PaymentType paymentType}) async {
    Map body;
    body = {
      "driverTripMasterId": paymentType.passengerTripMasterId,
      "paymentMode": paymentType.paymentMode
    };
    var jsonData = null;
    dynamic res = await HTTP.post(updatePaymentMode(), body);
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
     
      
    } else {
      throw "Can't update.";
    }
  }
}


PaymentService paymentService = PaymentService();



    // @POST(NetworkConfig.UPDATE_PAYMENT_MODE)
    // Call<PaymentType> updatePaymentMode(@Header(NetworkConfig.AUTH_TOKEN)String token, @Body PaymentType paymentType);




//     package sgs.env.user.data.network;

// import sgs.env.user.BuildConfig;

// public class NetworkConfig {


// 	public static final String BASE_URL = BuildConfig.BASE_URL;
// 	public static final String PROMOTIONS_BASE_URL = BuildConfig.PROMOTIONS_BASE_URL;


/*
	public static final String BASE_URL = "http://192.168.43.234:5001";
	public static final String PROMOTIONS_BASE_URL = "http://192.168.43.234:5001/promo/";
*/

//     public static final String AUTH_TOKEN = "x-access-token";

//     public static final String GET_DRIVER_LOC = "userTrip/getDriverLocation";

//     public static final String GET_DRIVER_DETAILS = "userTrip/getDriverDetails";

//     public static final String LOGIN_URL = "login/userLogin";

//     public static final String VALIDATE_USER = "login/isValidUser";

//     public static final String USER_REGISTRATION = "/login/userRegistration";

//     public static final String TRIP_HISTORY =
//             "userTrip/getUserTripHistory/{userid}/{pageNumber}/{numberOfItems}";

//     public static final String PROFILE_UPDATE = "user/updateProfile";

//     public static final String RATE_TRIP = "userTrip/ratingByUser/{tripId}/{rating}";

//     public static final String RIDE_NOW = "userTrip/rideNow";

//     public static final String CANCEL_TRIP = "userTrip/cancelUserTrip";

//     public static final String LOGOUT = "user/userLogout";

//     public static final String ADD_FAVIORITE_ADDRESS = "user/favouriteAddress/add";

//     public static final String DELETE_FAVIORITE_ADDRESS = "user/favouriteAddress/delete";

//     public static final String UPDATE_FAVIORITE_ADDRESS = "user/favouriteAddress/update";

//     public static final String GETALL_FAVIORITE_ADDRESS = "user/favouriteAddress/getAll/{userid}";

//     public static final String BOOK_NOW = "userTrip/bookNow";

//     public static final String CREATE_ORDER = "order/createOrder";

//     public static final String UPDATE_ORDER = "order/updateOrder";

//     public static final String SEARCH_DRIVERS = "userTrip/searchDrivers";

//     public static final String UPDATE_STATUS = "userTrip/updateUserTrip";

//     public static final String START_TRIP = "userTrip/startUserTrip";

//     public static final String GET_PRICE = "userTrip/getCompleteUserTripById";

//     public static final String GET_PAYMENT = "userTrip/checkPaymentStatusByPassengerMasterTripId";

//     public static final String SOS = "user/sos";

//     public static final String GENERATE_INVOICE = "userTrip/resendInvoice";

//     public static final String UPDATE_TOKEN = "user/FcmTokenUpdate";

//     public static final String GET_FEEDBACK_QUESTIONS = "feedbackQuestion/getQuestions";

//     public static final String ADD_USER_FEEDBACK = "userFeedback/postUserFeedback";

//     public static final String FETCH_LANDING_PAGE_SETTINGS = "login/fetchLandingPageSettings";

//     public static final String GET_PROMOTIONS_BY_USER_ID = "getPromotionsByUserId";

//     public static final String GET_ORDER_BY_ID = "order/getOrderById";

//     public static final String GET_USER_TRIP_STATUS = "userTrip/getUserTripStatus";

//     public static final String CREATE_REFERRAL = "users/{userId}/referral";

//     public static final String GET_REFERRER_DETAILS = "referrer-details";

//     public static final String PROMOTION_REGISTER = "promotionRegister";

//     public static final String UPDATE_REFERRAL_STATUS = "users/{userId}/referral/{referralId}";

//     public static final String REFERRAL_SUMMARY = "users/{userId}/referral-summary";

//     public static final String PROMOTIONS = "promotions";

//     public static final String UPDATE_INVOICE = "userTrip/updateInvoice";

//     public static final String VERIFY_TRANSACTION_STATUS = "order/verifyTransactionStatus";

//     public static final String LOG = "/userTrip/log";

//     public static final String GET_TOP_REFERRERS = "/user/topReferrers";

//     public static final String ADD_USER_DEVICE_INFO = "user/saveUserDeviceInfo";

//     public static final String UPDATE_PAYMENT_MODE = "userTrip/updatePaymentMode";

//     public static final String SEARCH_PLACE_API = "user/getGooglePlace";

//     public static final String ScheduleTripAPI = "userTrip/bookScheduleTrip";

//     public static final String getScheduleEstimation = "userTrip/getScheduleEstimation";

//     public static final String cancelScheduledTrip = "userTrip/cancelScheduledTrip";

// }


