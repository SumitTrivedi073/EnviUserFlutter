import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/fromtowidget.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SearchDriver extends StatefulWidget {
  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _SearchDriverPageState();
}

class _SearchDriverPageState extends State<SearchDriver> {
  final pagecontroller = PageController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(PageBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(children: [
        Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              FromToWidget(),
              Card(
                elevation: 5,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      height:40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: const robotoTextWidget(
                                textval: '3 Ride Option',
                                colorval: AppColor.black,
                                sizeval: 14,
                                fontWeight: FontWeight.w800),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(children: [
                                Container(
                                  width: 1,

                                  color: AppColor.darkgrey,
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.green,
                                    ))
                              ]),
                              Row(children: [
                                Container(
                                  width: 1,

                                  color: AppColor.darkgrey,
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.green,
                                    )),
                                Container(
                                  width: 1,
                                  color: AppColor.grey,
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: AppColor.grey,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      margin: const EdgeInsets.all(10),
                      color: const Color(0xFFE4F3F5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            const Padding(padding: EdgeInsets.all(8),
                            child: robotoTextWidget(textval: '7 Minutes Away',
                                colorval: AppColor.black,
                                sizeval: 16,
                                fontWeight: FontWeight.w600),),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              RatingBar.builder(
                              initialRating: 4,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                                Card(
                                  child: Image.network("https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE",
                                    fit: BoxFit.fill,height: 40,
                                    width: 50,),
                                )
                            ],)
                          ],)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    ));
  }
}
