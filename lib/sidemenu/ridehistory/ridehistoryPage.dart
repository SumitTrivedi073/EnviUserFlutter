import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/string.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/Constant.dart';

class RideHistoryPage extends StatefulWidget {
  @override
  State<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {
  bool _isFirstLoadRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(PageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            AppBarInsideWidget(
              title: TitelRideHistory,
            ),
            totalTripHeader(),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: _buildPosts(context)),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildPosts(BuildContext context) {
    return InkWell(
        onTap: () {
          //onSelectTripDetailPage(context);
        },
        child: ListView.builder(
          //controller: _controller,

          itemBuilder: (context, index) {
            return ListItem();
          },
          itemCount: 2,
          padding: const EdgeInsets.all(8),
        ));
  }

  Card ListItem() {
    return Card(
        elevation: 4,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: AppColor.border,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CellRow1(),
              CellRow2(),
              CellRow3(),
            ]));
  }

  Container CellRow1() {
    return Container(
      color: AppColor.cellheader,
      height: 38,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      foregroundDecoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          border: Border.all(color: AppColor.border, width: 1.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: const [
            Icon(
              Icons.nights_stay_sharp,
              color: AppColor.black,
            ),
            robotoTextWidget(
              textval: "Yesterday 8:15 PM",
              colorval: AppColor.black,
              sizeval: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ]),
          const robotoTextWidget(
            textval: "₹ 130",
            colorval: AppColor.black,
            sizeval: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Container CellRow2() {
    return Container(
      color: AppColor.white,
      height: 94,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.star,
                        color: AppColor.butgreen,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      robotoTextWidget(
                        textval: "Kempegowda International Airport",
                        colorval: AppColor.black,
                        sizeval: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 25),
                      ),
                      robotoTextWidget(
                        textval: "From Home",
                        colorval: AppColor.greyblack,
                        sizeval: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ],
              ),
              Image.network(
                "https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE",
                fit: BoxFit.fill,
                height: 40,
                width: 40,
              ),
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: const [
                Padding(
                  padding: EdgeInsets.only(left: 25),
                ),
                robotoTextWidget(
                  textval: "18 Kms",
                  colorval: AppColor.darkgrey,
                  sizeval: 13.0,
                  fontWeight: FontWeight.w800,
                ),
              ]),
              const robotoTextWidget(
                textval: "KA03 SS 4928",
                colorval: AppColor.darkgrey,
                sizeval: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container CellRow3() {
    return Container(
      color: AppColor.white,
      height: 38,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      foregroundDecoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: const Radius.circular(10)),
          border: Border.all(color: AppColor.border, width: 1.0)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Align(
          alignment: Alignment.center,
          child: MaterialButton(
            child: const robotoTextWidget(
              textval: "INVOICE",
              colorval: AppColor.butgreen,
              sizeval: 14.0,
              fontWeight: FontWeight.bold,
            ),
            onPressed: () {},
          ),
        ),
        Container(
          width: 1,
          color: AppColor.border,
        ),
        MaterialButton(
          child: const robotoTextWidget(
            textval: "SUPPORT",
            colorval: AppColor.butgreen,
            sizeval: 14.0,
            fontWeight: FontWeight.bold,
          ),
          onPressed: () {},
        ),
      ]),
    );
  }

  Card totalTripHeader() {
    return Card(
      elevation: 5,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: AppColor.detailheader,
      child: Container(
        color: AppColor.detailheader,
        height: 56,
        margin: const EdgeInsets.only(left: 5, right: 5),
        padding: const EdgeInsets.only(top: 9, bottom: 5, right: 5),
        foregroundDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        //

        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                    children: const [
                      RotatedBox(
                        quarterTurns: 3,
                        child: robotoTextWidget(
                          textval: "YOUR\nSTATS",
                          colorval: AppColor.greyblack,
                          sizeval: 13.0,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: const [
                      robotoTextWidget(
                        textval: "22",
                        colorval: AppColor.white,
                        sizeval: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      robotoTextWidget(
                        textval: "Rides Taken",
                        colorval: AppColor.lightwhite,
                        sizeval: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: const [
                      robotoTextWidget(
                        textval: "175 Kg",
                        colorval: AppColor.white,
                        sizeval: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      robotoTextWidget(
                        textval: "CO2 Emission Prevented",
                        colorval: AppColor.lightwhite,
                        sizeval: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
