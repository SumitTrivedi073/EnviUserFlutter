import 'dart:convert';

import 'package:envi/provider/model/tripDataModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../sidemenu/onRide/model/SosModel.dart';
import '../theme/color.dart';
import '../theme/images.dart';
import '../theme/string.dart';
import '../theme/theme.dart';
import '../utils/utility.dart';
import '../web_service/APIDirectory.dart';
import 'robotoTextWidget.dart';
import '../web_service/Constant.dart';
import 'package:envi/web_service/HTTP.dart'as HTTP;

class RatingBarWidget extends StatefulWidget {
  final TripDataModel? livetripData;

  // receive data from the FirstScreen as a parameter
  const RatingBarWidget({Key? key, required this.livetripData})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _RatingBarWidgetPageState();
}


class _RatingBarWidgetPageState extends State<RatingBarWidget> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.network(
                      encodeImgURLString(
                          widget.livetripData!.driverInfo!.driverImgUrl),
                           errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          Images.personPlaceHolderImage,
                          height: 50,
                          width: 50,
                        );
                      },
                      fit: BoxFit.fill,
                      height: 50,
                      width: 50,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    robotoTextWidget(
                        textval: rateYourDriverText,
                        colorval: AppColor.black,
                        sizeval: 14.0,
                        fontWeight: FontWeight.w800),
                    const SizedBox(
                      height: 7,
                    ),
                    RatingBar.builder(
                      initialRating: widget.livetripData!.driverRating!=null && widget.livetripData!.driverRating!.rating!.toDouble()!=null ?widget.livetripData!.driverRating!.rating!.toDouble():0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 27,
                      unratedColor: AppColor.border,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        submitRating(rating);
                      },
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Future<void> submitRating(double rating) async {

    dynamic res =
        await HTTP.get(submitDriverRating(widget.livetripData!.tripInfo!.passengerTripMasterId,rating));

    if (res != null && res.statusCode != null && res.statusCode == 200) {
      print(jsonDecode(res.body));
      var jsonData = json.decode(res.body);
      SosModel sosModel = SosModel.fromJson(jsonData);
      if(sosModel.message!=null) {
        showSnackbar(context, sosModel.message);
      }
    } else {
      throw "Rating Api not worked.";
    }
  }
}
