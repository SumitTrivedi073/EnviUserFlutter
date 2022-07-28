import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/string.dart';
import '../../../uiwidget/robotoTextWidget.dart';
import '../../../web_service/Constant.dart';

class UpcomingRidesPage extends StatefulWidget {
  @override
  State<UpcomingRidesPage> createState() => _UpcomingRidesPageState();
}

class _UpcomingRidesPageState extends State<UpcomingRidesPage> {
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
              title: TitelUpcomingRides,
            ),
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
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ListItem();
          },
          itemCount: 2,
          padding: const EdgeInsets.all(8),
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 0.5,
              indent: 20,
              endIndent: 20,
              color: Colors.transparent,
            );
          },
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
            Container(
              height: 1,
              color: AppColor.border,
            ),
            CellRow2(),
            Container(
              height: 1,
              color: AppColor.border,
            ),
            CellRow3(),
          ]),
    );
  }

  Container CellRow1() {
    return Container(
      color: AppColor.alfaorange.withOpacity(.3),
      height: 38,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: const [
            Icon(
              Icons.nightlife,
              color: AppColor.black,
            ),
            robotoTextWidget(
              textval: "Tomorrow, 11:00 AM",
              colorval: AppColor.black,
              sizeval: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ]),
          const robotoTextWidget(
            textval: "₹ ~130",
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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(PageBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: AppColor.alfaorange.withOpacity(0.1),
        height: 94,
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
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
                        robotoTextWidget(
                          textval: "From Home",
                          colorval: AppColor.black,
                          sizeval: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                  ],
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
                  robotoTextWidget(
                    textval: "18 Kms",
                    colorval: AppColor.greyblack,
                    sizeval: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container CellRow3() {
    return Container(
      color: AppColor.white,
      height: 38,
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            child: robotoTextWidget(
              textval: CancelBooking,
              colorval: Color(0xFFED0000),
              sizeval: 14.0,
              fontWeight: FontWeight.bold,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
