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
    double totalTax =
        widget.livetripData!.tripInfo.arrivalAtDestination!.cgst.toDouble() +
            widget.livetripData!.tripInfo.arrivalAtDestination!.sgst.toDouble();
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
                  subtitle:  widget.livetripData!.tripInfo
                      .priceClass.discountPercent.toDouble()!=0.0? robotoTextWidget(
                      textval: 'Includes ${widget.livetripData!.tripInfo.priceClass.discountPercent}% discount',
                      colorval: AppColor.textgray,
                      sizeval: 14,
                      fontWeight: FontWeight.w400):Container(),
                  trailing: robotoTextWidget(
                      textval: widget.livetripData!.tripInfo
                          .arrivalAtDestination!.amountTobeCollected
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
                        child: Column(children: [
                          Row(
                            children: [
                              robotoTextWidget(
                                  textval: distanceTravelledText,
                                  colorval: AppColor.grey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w600),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: widget.livetripData!.tripInfo
                                      .arrivalAtDestination!.distanceTravelled
                                      .toString(),
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w400),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              robotoTextWidget(
                                  textval: ratePerKmText,
                                  colorval: AppColor.grey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w600),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: widget.livetripData!.tripInfo
                                      .arrivalAtDestination!.perKMPrice
                                      .toString(),
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w400),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              robotoTextWidget(
                                  textval: totalFareText,
                                  colorval: AppColor.grey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w600),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: widget.livetripData!.tripInfo
                                      .arrivalAtDestination!.kmFare
                                      .toString(),
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w400),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          widget.livetripData!.tripInfo
                              .arrivalAtDestination!.discount.toDouble()!=0.0? Row(
                            children: [
                              robotoTextWidget(
                                  textval: lessDiscountText,
                                  colorval: AppColor.grey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w600),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: widget.livetripData!.tripInfo
                                      .arrivalAtDestination!.discount
                                      .toString(),
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w400),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ):Container(),
                          widget.livetripData!.tripInfo
                              .arrivalAtDestination!.tollAmount.toDouble()!=0.0? Row(
                            children: [
                              robotoTextWidget(
                                  textval: tollsText,
                                  colorval: AppColor.grey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w600),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: widget.livetripData!.tripInfo
                                      .arrivalAtDestination!.tollAmount
                                      .toString(),
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w400),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ):Container(),
                          Row(
                            children: [
                              robotoTextWidget(
                                  textval: taxesText,
                                  colorval: AppColor.grey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w600),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: totalTax.round().toString() != null
                                      ? totalTax.round().toString()
                                      : '0',
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w400),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              robotoTextWidget(
                                  textval: amountPayableText,
                                  colorval: AppColor.grey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w600),
                              const Spacer(),
                              robotoTextWidget(
                                textval: widget.livetripData!.tripInfo
                                    .arrivalAtDestination!.amountTobeCollected
                                    .toString(),
                                colorval: AppColor.black,
                                sizeval: 14,
                                fontWeight: FontWeight.w800,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        ])),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
