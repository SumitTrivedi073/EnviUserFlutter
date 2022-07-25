import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/color.dart';
import '../theme/string.dart';

class PaymentModeOptionWidget extends StatelessWidget {
   final String strpayment;

  const PaymentModeOptionWidget(
      {required this.strpayment,
       });

  @override
  Widget build(BuildContext context) {
    return Container(

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
                robotoTextWidget(
                  textval: selectepaymentmode,
                  colorval: AppColor.lightgreen,
                  sizeval: 18,
                  fontWeight: FontWeight.bold,
                ),

                Container(
                  margin: const EdgeInsets.only(
                      top: 5, left: 10, right: 10, bottom: 5),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  child: const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                ),
            Container(
              child: ListView.builder(
                //controller: _controller,

                itemBuilder: (context, index) {
                  return ListItem();
                },
                itemCount: 2,
                padding: EdgeInsets.all(8),
              ),
              ],
            ),
          )),
    );
  }
   Card ListItem(){
     return Card(
         elevation:1,

         child: Container(


             child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   CellRow1(),
                   CellRow2(),
                   CellRow3(),
                 ])));

   }
   Container CellRow1(){
     return Container(color: AppColor.cellheader,
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
               Icons.nightlife,color: AppColor.lightgreen,
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
       ),);
   }
}
