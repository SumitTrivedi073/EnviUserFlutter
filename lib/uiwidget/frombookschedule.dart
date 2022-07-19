import 'package:envi/theme/color.dart';
import 'package:flutter/material.dart';

class FromBookScheduleWidget extends StatefulWidget {
  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _FromBookScheduleWidgetPageState();
}

class _FromBookScheduleWidgetPageState extends State<FromBookScheduleWidget> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 140,
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
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        color: isButtonPressed ? Colors.white : Colors.white,
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w800,
                              fontSize: 18),
                        ),
                        onPressed: () {},
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Color(yellow),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        child: const Text('Book for later?',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
