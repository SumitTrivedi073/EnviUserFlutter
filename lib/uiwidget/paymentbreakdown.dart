import 'package:envi/provider/model/tripDataModel.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import 'robotoTextWidget.dart';

class PaymentBreakdownWidget extends StatefulWidget {
  final TripDataModel? livetripData;

  // receive data from the FirstScreen as a parameter
  const PaymentBreakdownWidget({Key? key, required this.livetripData})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _PaymentBreakdownWidgetPageState();
}

class _PaymentBreakdownWidgetPageState extends State<PaymentBreakdownWidget> {
  bool arrowClicked = false;
  List<String> breakDownNames = [
    distanceTravelledText,
    ratePerKmText,
    totalFareText,
    lessDiscountText,
    tollsText,
    taxesText,
    amountPayableText
  ];

  @override
  Widget build(BuildContext context) {
    List<String> breakDownVals = [
      widget.livetripData!.tripInfo.priceClass.distance.toString(),
      widget.livetripData!.tripInfo.priceClass.perKmFare.toString(),
      widget.livetripData!.tripInfo.priceClass.baseFare.toString(),
      widget.livetripData!.tripInfo.priceClass.sellerDiscount.toString(),
      widget.livetripData!.tripInfo.priceClass.tollCharges.toString(),
      widget.livetripData!.tripInfo.priceClass.stateTax.toString(),
      widget.livetripData!.tripInfo.priceClass.amountToBeCollected.toString(),
    ];
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
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  title: robotoTextWidget(
                      textval: yourFareText,
                      colorval: AppColor.black,
                      sizeval: 16,
                      fontWeight: FontWeight.w600),
                  subtitle: robotoTextWidget(
                      textval: includesdiscountText,
                      colorval: AppColor.textgray,
                      sizeval: 14,
                      fontWeight: FontWeight.w400),
                  trailing: robotoTextWidget(
                      textval: widget
                          .livetripData!.tripInfo.priceClass.amountToBeCollected
                          .toString(),
                      colorval: AppColor.darkGreen,
                      sizeval: 20,
                      fontWeight: FontWeight.w800),
                ),
                ExpansionTile(
                  onExpansionChanged: (value) {
                    setState(() {
                      arrowClicked = !arrowClicked;
                    });
                  },
                  //  backgroundColor: Colors.white,
                  leading: (arrowClicked)
                      ? const Icon(
                          Icons.arrow_drop_up,
                          color: AppColor.black,
                        )
                      : const Icon(Icons.arrow_drop_down,
                          color: AppColor.black),
                  trailing: const Icon(Icons.share, color: AppColor.black),
                  title: robotoTextWidget(
                      textval: breakdownText,
                      colorval: AppColor.black,
                      sizeval: 14,
                      fontWeight: FontWeight.w600),
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: List.generate(
                              breakDownNames.length,
                              (index) => Row(
                                    children: [
                                      robotoTextWidget(
                                          textval: breakDownNames[index],
                                          colorval: AppColor.grey,
                                          sizeval: 14,
                                          fontWeight: FontWeight.w600),
                                      const Spacer(),
                                      robotoTextWidget(
                                          textval: breakDownVals[index],
                                          colorval: AppColor.black,
                                          sizeval: 14,
                                          fontWeight: (index == 2 || index == 6)
                                              ? FontWeight.w800
                                              : FontWeight.w400),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),

                          ),
                        )),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
