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
  
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalTax =
        widget.livetripData!.tripInfo!.arrivalAtDestination!.cgst.toDouble() +
            widget.livetripData!.tripInfo!.arrivalAtDestination!.sgst.toDouble();
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
                  subtitle:  widget.livetripData!.tripInfo!
                      .priceClass!.discountPercent.toDouble()!=0.0? robotoTextWidget(
                      textval: 'Includes ${widget.livetripData!.tripInfo!.priceClass!.discountPercent.round()}% discount',
                      colorval: AppColor.textgray,
                      sizeval: 14,
                      fontWeight: FontWeight.w400):Container(),
                  trailing: robotoTextWidget(
                      textval: '₹ ${widget.livetripData!.tripInfo!
                          .arrivalAtDestination!.amountTobeCollected
                          .toDouble().round().toString()}',
                      colorval: AppColor.darkGreen,
                      sizeval: 25,
                      fontWeight: FontWeight.w800),
                ),
                Theme(
                    data: ThemeData(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                  onExpansionChanged: (value) {
                   if(mounted){
                     setState(() {
                       arrowClicked = !arrowClicked;
                     });
                   }
                  },
                  //  backgroundColor: Colors.white,
                  leading: (arrowClicked)
                      ? const Icon(
                          Icons.arrow_drop_down,
                          color: AppColor.black,
                        )
                      : const Icon(Icons.arrow_right_rounded,
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
                                  colorval: AppColor.darkgrey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w500),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: '${widget.livetripData!.tripInfo!
                                      .arrivalAtDestination!.distanceTravelled
                                      .toStringAsFixed(2)} Kms',
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w200),],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              robotoTextWidget(
                                  textval: ratePerKmText,
                                  colorval: AppColor.darkgrey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w500),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: '× ${widget.livetripData!.tripInfo!
                                      .arrivalAtDestination!.perKMPrice
                                      .toStringAsFixed(2)} ₹',
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w200),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: AppColor.grey,
                            height: 1,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              robotoTextWidget(
                                  textval: totalFareText,
                                  colorval: AppColor.darkgrey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w500),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: '${widget.livetripData!.tripInfo
                                  !.arrivalAtDestination!.kmFare
                                      .toStringAsFixed(2)} ₹',
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w800),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          widget.livetripData!.tripInfo
                          !.arrivalAtDestination!.discount.toDouble()!=0.0? Row(
                            children: [
                              robotoTextWidget(
                                  textval: lessDiscountText,
                                  colorval: AppColor.darkgrey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w500),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: '- ${widget.livetripData!.tripInfo
                                  !.arrivalAtDestination!.discount
                                      .toStringAsFixed(2)} ₹',
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w200),
                            ],
                          ):Container(),
                          const SizedBox(height: 5),
                          widget.livetripData!.tripInfo
                          !.arrivalAtDestination!.tollAmount.toDouble()!=0.0? Row(
                            children: [
                              robotoTextWidget(
                                  textval: tollsText,
                                  colorval: AppColor.darkgrey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w500),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: '${widget.livetripData!.tripInfo
                                  !.arrivalAtDestination!.tollAmount
                                      .toStringAsFixed(2)} ₹',
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w200),
                            ],
                          ):Container(),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              robotoTextWidget(
                                  textval: taxesText,
                                  colorval: AppColor.darkgrey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w500),
                              const Spacer(),
                              robotoTextWidget(
                                  textval: totalTax.toString() != null
                                      ? '${totalTax.toStringAsFixed(2)} ₹'
                                      : '0',
                                  colorval: AppColor.black,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w200),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          const Divider(
                            color: AppColor.grey,
                            height: 1,
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              robotoTextWidget(
                                  textval: amountPayableText,
                                  colorval: AppColor.darkgrey,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w500),
                              const Spacer(),
                              robotoTextWidget(
                                textval: '${widget.livetripData!.tripInfo
                                !.arrivalAtDestination!.amountTobeCollected
                                    .toDouble().round().toString()} ₹',
                                colorval: AppColor.black,
                                sizeval: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ],
                          ),
                        ])),
                  ],
                )),
              ],
            ),
          )),
    );
  }
}
