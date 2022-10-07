import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../UiWidget/appbar.dart';
import '../UiWidget/cardbanner.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/paymentModeOptionWidget.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../web_service/Constant.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool arrowClicked = false;
  List<String> breakDownNames = [distanceTravelledText,totalFareText,lessDiscountText,tollsText,taxesText,amountPayableText];
  List<String> breakDownVals = ['13.0 Kms','x 18.00 ₹','234.00 ₹','- 40.0 ₹','70.00 ₹','32.00 ₹','296.00'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(PageBackgroundImage),
            fit: BoxFit.fill,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Card(
                child: Image.network(
                  placeHolderImage,
                  fit: BoxFit.fill,
                  height: 40,
                  width: 50,
                ),
              )
            ],
            centerTitle: true,
            title: Text(
              envi,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SFCompactText',
                  fontWeight: FontWeight.w200,
                  fontSize: 18),
            ),
            backgroundColor: AppColor.greyblack,
            elevation: 4,
            leading: IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                CardBanner(
                    title: youHaveArrivedText,
                    image: 'assets/images/driver_arrived_img.png'),
                SizedBox(
                  height: 76,
                  child: Card(
                    child: Row(
                      children: [
                        Image.network(
                          placeHolderImage,
                          fit: BoxFit.fill,
                          height: 54,
                          width: 50,
                        ),
                        Flexible(
                          flex: 2,
                          child: Column(
                            children: [
                              robotoTextWidget(
                                  textval: rateYourDriverText,
                                  colorval: AppColor.black,
                                  sizeval: 14.0,
                                  fontWeight: FontWeight.bold),
                              const SizedBox(
                                height: 7,
                              ),
                              RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 27,
                                unratedColor: AppColor.border,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: robotoTextWidget(
                            textval: yourFareText,
                            colorval: AppColor.black,
                            sizeval: 14,
                            fontWeight: FontWeight.normal),
                        subtitle: robotoTextWidget(
                            textval: includesdiscountText,
                            colorval: AppColor.textgray,
                            sizeval: 14,
                            fontWeight: FontWeight.normal),
                        trailing: const robotoTextWidget(
                            textval: '₹296',
                            colorval: AppColor.darkGreen,
                            sizeval: 40,
                            fontWeight: FontWeight.normal),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      ExpansionTile(
                        onExpansionChanged: (value) {
                          setState(() {
                            arrowClicked = !arrowClicked;
                          });
                        },
                        backgroundColor: Colors.yellow[50],
                        leading: (arrowClicked)
                            ? Icon(Icons.arrow_drop_up)
                            : Icon(Icons.arrow_drop_down),
                        trailing: const Icon(Icons.share),
                        title: robotoTextWidget(
                            textval: breakdownText,
                            colorval: AppColor.black,
                            sizeval: 14,
                            fontWeight: FontWeight.bold),
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: 
                                List.generate(7, (index) => Row(
                                  children: [
                                  //  robotoTextWidget(textval: breakDownNames[index], colorval: colorval, sizeval: sizeval, fontWeight: fontWeight)
                                  ],
                                ))
                                
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                PaymentModeOptionWidget(
                  strpaymentOptions: "qr_code,online,cash",
                  selectedOption: "qr_code",
                ),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.greyblack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: robotoTextWidget(
                        textval: confirm,
                        colorval: AppColor.white,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
