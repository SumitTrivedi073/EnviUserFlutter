import 'package:envi/theme/color.dart';
import 'package:flutter/material.dart';

class FromToWidget extends StatefulWidget {
  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _FromToWidgetPageState();
}

class _FromToWidgetPageState extends State<FromToWidget> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 180,
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
                GestureDetector(
                    onTap: () {
                      print("Tapped a Container");
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/from_location.png',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Phoenix Mall, Nagar Road",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w200,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    )),

                Stack(alignment: Alignment.centerRight, children: <Widget>[
                  Container(
                    height: 2,
                    child: Divider(
                      color: Colors.grey,
                      height: 2,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color(lightwhite),
                        border: Border.all(
                            color: Color(grey), // Set border color
                            width: 1.0),   // Set border width
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10.0)), // Set rounded corner radius
                    ),
                    child: const Text("5 Km",style: TextStyle(color: Colors.black,
                    fontFamily: 'Roboto',fontWeight: FontWeight.normal),),
                  ),

                ]),
                GestureDetector(
                    onTap: () {
                      print("Tapped a Container");
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/to_location.png',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "35 - Sesame Street",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w200,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}
