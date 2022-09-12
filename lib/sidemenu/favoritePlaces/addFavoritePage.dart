import 'package:envi/database/favoritesData.dart';
import 'package:envi/database/favoritesDataDao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/database.dart';
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../theme/theme.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/Constant.dart';
import '../upcomingride/model/ScheduleTripModel.dart';

class AddEditFavoritePlacesPage extends StatefulWidget {
  const AddEditFavoritePlacesPage({Key? key, required this.isforedit,required this.data,required this.titleEditable}) : super(key: key);
  final String isforedit;
  final String titleEditable;
final FavoritesData? data;
  @override
  State<AddEditFavoritePlacesPage> createState() => _AddEditFavoritePlacesPageState();
}

class _AddEditFavoritePlacesPageState extends State<AddEditFavoritePlacesPage> {


  final _formKey = GlobalKey<FormState>();
  late final FavoritesDataDao dao;
  TextEditingController titlecontroller = new TextEditingController();
  TextEditingController addresscontroller = new TextEditingController();
  CameraPosition? _cameraPosition;
  @override
  void initState()  {
    super.initState();
    loadData();
    _cameraPosition = const CameraPosition(target: LatLng(0, 0), zoom: 10.0);

    // _controller = new ScrollController()..addListener(_loadMore);
  }
  Future<void> loadData() async {
    final database = await $FloorFlutterDatabase
        .databaseBuilder('envi_user.db')
        .build();
    dao = database.taskDao;
    //List<FavoritesData>  temparr =  await dao.getFavoriate() ;
    // setState(() {
    //
    // });
    //findTaskByidentifier("5bf57942-b1be-4df2-a9a9-1e588bf8e1dd");

  }
  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(PageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(

          children: [
            AppBarInsideWidget(
              title: TitelEditFavoritePlace,
            ),


        Form(
          key: _formKey,
          child:Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 22,),

                Container(
                    color: AppColor.white.withOpacity(0.1),
                    padding:  const EdgeInsets.only(left: 20, right: 20),

                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children:  [
                            robotoTextWidget(
                              textval: PlaceTitle,
                              colorval: AppColor.grey,
                              sizeval: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ]),

                        ],
                      ),
                      const SizedBox(height: 5,),
                      Card(child: TextFormField(
                        controller: titlecontroller,
                        readOnly: widget.titleEditable == "1" ? false : true,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: AppColor.black),
                        decoration: const InputDecoration(
                          hintText: "Please enter Title!",
                          hintStyle: TextStyle(color: Colors.black45),

                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter valid OTP!';
                          }
                          return null;
                        },
                      )
                        ,),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children:  [
                            robotoTextWidget(
                              textval: Address,
                              colorval: AppColor.grey,
                              sizeval: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ]),

                        ],
                      ),
                       GestureDetector(
                        onTap: () {
                          setState(() {

                          });
                          print("Tapped a Container");
                        },
                        child: Card(child:TextFormField(
                        controller: addresscontroller,
                        readOnly: true,

                        style: const TextStyle(color: AppColor.black),
                        decoration: const InputDecoration(
                          hintText: "Please enter address",
                          hintStyle: TextStyle(color: Colors.black45),

                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter valid OTP!';
                          }
                          return null;
                        },
                      )
                        )
                        ,),
                      const SizedBox(height: 22,),
                       Container(
                         height: 300,
                         child: GoogleMap(
                         mapType: MapType.normal,
                         initialCameraPosition: _cameraPosition!,
                         // onMapCreated: (GoogleMapController controller) {
                         //   controller.setMapStyle(MapStyle.mapStyles);
                         //   _controller = (controller);
                         //
                         //   _controller?.animateCamera(
                         //       CameraUpdate.newCameraPosition(_cameraPosition!));
                         // },
                         myLocationEnabled: true,
                         myLocationButtonEnabled: false,
                         mapToolbarEnabled: false,
                         zoomGesturesEnabled: true,
                         rotateGesturesEnabled: true,
                         zoomControlsEnabled: false,
                         onCameraIdle: () {

                         },

                       ),),
                        const SizedBox(height: 22,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children:  [
                            MaterialButton(
                             
                              height: 40,
                              onPressed: () {



                              },
                              child:  Row(children:  [
                                SvgPicture.asset(
                                  "assets/svg/place-delete.svg",
                                  width: 22,
                                  height: 24,
                                  color: AppColor.red,
                                ),
                                SizedBox(width: 10,),
                                robotoTextWidget(
                                    textval: widget.titleEditable == "1" ? Deletelocation : Clearlocation,
                                    colorval: AppColor.red,
                                    sizeval: 16.0,
                                    fontWeight: FontWeight.normal),
                              ]),
                            )
                          ]),

                        ],
                      ),

                    ],)

                ),



              ],),)),


            Container(
color: AppColor.alfaorange,

                //padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 50),
                child:MaterialButton(
                  color: AppColor.darkgrey,
                  height: 40,
                  onPressed: () {



                  },
                  child:  robotoTextWidget(
                      textval: savetext,
                      colorval: AppColor.white,
                      sizeval: 16.0,
                      fontWeight: FontWeight.bold),

                ),
            ),
            const SizedBox(height: 5,),

          ],
        ),
      ),
    );
  }



  Container presetplace(){
    return Container(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 22,),

         Container(
                color: AppColor.white.withOpacity(0.1),
                padding:  const EdgeInsets.only(left: 20, right: 20),

                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children:  [
                        robotoTextWidget(
                          textval: PlaceTitle,
                          colorval: AppColor.grey,
                          sizeval: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ]),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children:  [

                        const SizedBox(width: 22,),
                        // Expanded(child: robotoTextWidget(
                        //   textval: arraddress[index].address,
                        //   colorval: AppColor.black,
                        //   sizeval: 14.0,
                        //   fontWeight: FontWeight.normal,
                        // ),),
                        robotoTextWidget(
                          textval: "arraddress[index].address",
                          colorval: AppColor.darkgrey,
                          sizeval: 14.0,
                          fontWeight: FontWeight.normal,
                        ),

                      ]),

                    ],
                  ),
                ],)

            ),

          const SizedBox(height: 20,),
          Container(
            height: 1,
            color: AppColor.border,
          ),
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              setState(() {

              });
              print("Tapped a Container");
            },
            child: Container(
                color: AppColor.white.withOpacity(0.1),
                padding:  const EdgeInsets.only(left: 20, right: 20),

                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children:  [
                        robotoTextWidget(
                          textval: Address,
                          colorval: AppColor.grey,
                          sizeval: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ]),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children:  [

                        const SizedBox(width: 22,),

                        robotoTextWidget(
                          textval: "arraddress[index].address",
                          colorval: AppColor.darkgrey,
                          sizeval: 14.0,
                          fontWeight: FontWeight.normal,
                        ),

                      ]),

                    ],
                  ),
                ],)

            ),),

          const SizedBox(height: 20,),
          Container(
            height: 1,
            color: AppColor.border,
          ),
          const SizedBox(height: 22,),
          Row(children:  [
            const SizedBox(width: 22,),
            robotoTextWidget(
              textval: customplacetext,
              colorval: AppColor.grey,
              sizeval: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ]),
          const SizedBox(height: 5,),
          Container(
            height: 1,
            color: AppColor.border,
          ),
        ],),);
  }

}
