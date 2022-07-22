import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/Constant.dart';

class UpcomingRidesPage extends StatefulWidget {

  @override
  State<UpcomingRidesPage> createState() => _UpcomingRidesPageState();
}

class _UpcomingRidesPageState extends State<UpcomingRidesPage> {
  bool _isFirstLoadRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image:  AssetImage(loginPageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child:  Column(
          children:  [
            const AppBarInsideWidget(title: "Upcoming Rides",),

            Expanded(
              child:  Container(
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
        child: Container(
          child: ListView.builder(
            //controller: _controller,

            itemBuilder: (context, index) {
              return ListItem();
            },
            itemCount: 2,
            padding: EdgeInsets.all(8),
          ),
        ));
  }


  Card ListItem(){
    return Card(
        elevation:1,

        child: Container(
color: Colors.transparent,

            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CellRow1(),
                  CellRow2(),
                  CellRow3(),
                ])));

  }
  Container CellRow1(){
    return Container(color: AppColor.lightorange,
      height: 38,
      padding: const EdgeInsets.only(top: 10,bottom: 10,left: 15,right:
      15),
      foregroundDecoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
          border: Border.all(
              color: AppColor.border,
              width: 1.0
          )
      ),
      //

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: const [
            Icon(
              Icons.nightlife,color: AppColor.black,
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
      ),);
  }
  Container CellRow2(){
    return  Container(color: AppColor.alfaorange,
      height: 94,
      padding: const EdgeInsets.only(top: 10,bottom: 10,left: 15,right:
      15),

      // decoration: BoxDecoration(
      //     border: Border.all( color: const
      //     Color(0xFFCECECE), width: 3.0,strokeAlign: StrokeAlign.inside,style: BorderStyle.solid),
      // ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Row(children: const [

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
                Row(children: const [


                  robotoTextWidget(
                    textval: "From Home",
                    colorval: AppColor.black,
                    sizeval: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ],

                ),

              ],),


          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children:  const [

              robotoTextWidget(
                textval: "18 Kms",
                colorval: AppColor.greyblack,
                sizeval: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ]),


          ],
        ),
      ],),
    );
  }

  Container CellRow3(){
    return Container(color: AppColor.white,
      height: 38,
      padding: EdgeInsets.only(left: 15,right:
      15),
      foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
          border: Border.all(
              color: AppColor.border,
              width: 1.0
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          MaterialButton(
            child: robotoTextWidget(textval: "CANCEL BOOKING", colorval: AppColor.red,sizeval: 14.0,fontWeight: FontWeight.bold,),
            onPressed: () {

            },
          ),
        ],
      ),);
  }

}