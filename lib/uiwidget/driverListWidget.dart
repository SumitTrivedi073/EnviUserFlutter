import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/string.dart';

class DriverListItem extends StatefulWidget {
  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _DriverListItemPageState();
}

class _DriverListItemPageState extends State<DriverListItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 40,
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
            margin: const EdgeInsets.all(5),
            color: const Color(0xFFE4F3F5),
            child:Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const robotoTextWidget(
                            textval: '7 Minutes Away',
                            colorval: AppColor.black,
                            sizeval: 16,
                            fontWeight: FontWeight.w600),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar.builder(
                              initialRating: 4,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding: const EdgeInsets.symmetric(
                                  horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                            Card(
                              child: Image.network(
                                "https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE",
                                fit: BoxFit.fill,
                                height: 40,
                                width: 50,
                              ),
                            )
                          ],
                        ),],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/car-type-sedan.svg",
                          width: 40,
                          height: 30,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children:  [
                            const robotoTextWidget(textval: "Hatchback",
                                colorval: AppColor.black,
                                sizeval: 14,
                                fontWeight: FontWeight.w200),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                        'assets/images/passengers-icon.png',
                                        height: 15,
                                        width: 15,
                                        fit:BoxFit.cover
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const robotoTextWidget(textval: "3 People",
                                        colorval:  AppColor.black,
                                        sizeval: 14,
                                        fontWeight: FontWeight.w200)
                                  ],),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                        'assets/images/weight-icon.png',
                                        height: 15,
                                        width: 15,
                                        fit:BoxFit.cover
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const robotoTextWidget(textval: "7 Kg",
                                        colorval:  AppColor.black,
                                        sizeval: 14,
                                        fontWeight: FontWeight.w200)
                                  ],)
                              ],
                            )
                          ],
                        )
                      ],
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      color: AppColor.border,
                      height: 2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        robotoTextWidget(textval: estimateFare,
                            colorval: AppColor.darkgrey,
                            sizeval: 12,
                            fontWeight: FontWeight.w600),

                        IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.info_outlined,
                              size: 20.0,
                              color: Colors.grey,)
                        )
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:  [
                        const robotoTextWidget(textval: "₹220",
                            colorval: AppColor.black,
                            sizeval: 20,
                            fontWeight: FontWeight.w800),
                        const Text(
                          "₹350",
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColor.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                              decoration: TextDecoration.lineThrough),
                        ),

                        Column(
                          children: const [
                            robotoTextWidget(textval: "Special Offer",
                                colorval: AppColor.purple,
                                sizeval: 14,
                                fontWeight: FontWeight.w800),
                            robotoTextWidget(textval: "20% Off",
                                colorval: AppColor.purple,
                                sizeval: 13,
                                fontWeight: FontWeight.w400),
                          ],
                        )

                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
