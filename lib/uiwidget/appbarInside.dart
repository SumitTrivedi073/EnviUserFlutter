
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/color.dart';


class AppBarInsideWidget extends StatelessWidget{
  const AppBarInsideWidget({Key? key, required this.title}) : super(key: key);
  final String title;
  // @override
  // State<StatefulWidget> createState() => _AppBarInsidePageState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 150,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 80.0,
            left: 0.0,
            right: 0.0,
            child: Card(
              elevation: 4,
              color: AppColor.greyblack,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/svg/chevron-back-button.svg",
                        width: 22,
                        height: 24,

                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          robotoTextWidget(textval: title,colorval: AppColor.lightwhite,sizeval: 18.0,fontWeight: FontWeight.w800,),
                        ],
                      ),
                    ),

                    Card(
                      child: Image.network("https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE",
                        fit: BoxFit.fill,height: 40,
                        width: 40,),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class _AppBarInsidePageState extends State<AppBarInsideWidget> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Container(
//       height: 150,
//       child: Stack(
//         children: <Widget>[
//           Positioned(
//             top: 80.0,
//             left: 0.0,
//             right: 0.0,
//             child: Card(
//               elevation: 4,
//               color: Color(greyblack),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                   children: [
//                     IconButton(
//                       icon: SvgPicture.asset(
//                         "assets/svg/chevron-back-button.svg",
//                         width: 22,
//                         height: 24,
//
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//
//                     Container(
//                       alignment: Alignment.center,
//                       child: Row(
//                         children: [
//                           robotoTextWidget(textval: widget.title,colorval: AppColor.lightwhite,sizeval: 18.0,fontWeight: FontWeight.bold,),
//                         ],
//                       ),
//                     ),
//
//                     Card(
//                       child: Image.network("https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE",
//                         fit: BoxFit.fill,height: 40,
//                         width: 40,),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//
//   }
// }