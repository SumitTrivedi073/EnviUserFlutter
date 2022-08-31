
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/color.dart';
import 'navigationdrawer.dart';


class AppBarWidget extends StatefulWidget{
 @override
   State<StatefulWidget> createState() => _AppBarPageState();
  }

class _AppBarPageState extends State<AppBarWidget> {
  late SharedPreferences sharedPreferences ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();

  }

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();

  }

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
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            print("your menu action here");

                            Scaffold.of(context).openDrawer();
                          },
                        ),

                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: const [
                              Text("ENVI",
                                style: TextStyle(color: Colors.white,
                                    fontFamily: 'SFCompactText',
                                    fontWeight: FontWeight.w200,
                                    fontSize: 18),),
                             ],
                          ),
                        ),

                        Card(
                          child: Image.network("https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE",
                            fit: BoxFit.fill,height: 40,
                            width: 50,),
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