
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../theme/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _profilePageState();
}

class _profilePageState extends State<ProfilePage> {

  String bal = '0';
  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }



  @override
  Widget build(BuildContext context) {
    final panels = PageView(
      onPageChanged: (int page) {
        setState(() {
          currentPage = page;
        });
      },
      controller: PageController(initialPage: 0),
      children: <Widget>[
        Panel1(),
        Panel2(),
        Panel3(),
      ],
    );
    return Scaffold(
      //body
      body: Container(
        child: Stack(children: <Widget>[
          const SizedBox(height: 10,),
          Container(
            padding:  EdgeInsets.all(20),
           // margin: EdgeInsets.only(bottom: 15),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Row(
              //mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.start,children: [
                  IconButton(onPressed: () {  }, icon: Icon(Icons.keyboard_arrow_left,size: 20,),color: AppColor.grey,
                  ),
                ],

                ),
                ),

                Expanded(child:  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < 3; i++)
                      (i == currentPage ? circleBar(true) : circleBar(false))
                  ],)
                ),


              ],
            ),
              const SizedBox(height: 15,),

              robotoTextWidget(textval: envi, colorval: AppColor.darkGreen, sizeval: 17.0, fontWeight: FontWeight.bold),
              robotoTextWidget(textval: envichoosing, colorval: AppColor.black, sizeval: 17.0, fontWeight: FontWeight.bold),

            ],)
          ),


          panels,

        ]),
      ),
    );
  }
  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 7 : 6,
      width: isActive ? 7 : 6,
      decoration: BoxDecoration(
          color: isActive ? AppColor.greyblack: AppColor.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}

class Panel1 extends StatefulWidget {
 // Panel1({required Key key}) : super(key: key);

  @override
  _Panel1State createState() => _Panel1State();
}

class _Panel1State extends State<Panel1> {
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Form(
        key: _formKey,
        child: Container(

        margin: EdgeInsets.only(top: 100),
padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          robotoTextWidget(textval: profilemsg, colorval: AppColor.black, sizeval: 13.0, fontWeight: FontWeight.normal),
            const SizedBox(height: 20,),
            profileimage(),
            const SizedBox(height: 17,),
            Row(children: [
              Expanded(child: TextFormField(
                //controller: phoneController,
                keyboardType: TextInputType.phone,

                style: const TextStyle(color: AppColor.black),
                decoration: const InputDecoration(
                  hintText: "First Name",
                  hintStyle: TextStyle(color: Colors.black45),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp("^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}")
                          .hasMatch(value)) {
                    return 'Please enter First Name!';
                  }
                  return null;
                },
              ),),
              const SizedBox(width: 15,),
              Expanded(child: TextFormField(
                //controller: phoneController,
                keyboardType: TextInputType.phone,

                style: const TextStyle(color: AppColor.black),
                decoration: const InputDecoration(
                  hintText: "Last Name",
                  hintStyle: TextStyle(color: Colors.black45),
                ),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp("^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}")
                          .hasMatch(value)) {
                    return 'Please enter Last Name!';
                  }
                  return null;
                },
              ),),

            ],),
            const SizedBox(height: 40,),
            Container(
              color: AppColor.lightwhite,
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0),

              child: MaterialButton(
                minWidth: double.infinity,
                height: 45,
                onPressed: () {

                  setState(() {

                  });

                },


                child: robotoTextWidget(textval: continuebut, colorval: AppColor.black, sizeval: 17.0, fontWeight: FontWeight.bold),
              ),
            ),
        ],)


      ));

  }
  Widget profileimage(){
    return MaterialButton(
      height: 90,
      onPressed: () {

      },
      color: AppColor.lightwhite,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child:  ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: getNetworkImage(context, "https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE")
      ),
    );
  }
}

class Panel2 extends StatefulWidget {
 // Panel2({ Key key}) : super(key: key);

  @override
  _Panel2State createState() => _Panel2State();
}

class _Panel2State extends State<Panel2> {
  String selectedOption ="Male";
  List<String> arroption = ["Male","Female","I'd rather not say"];
  @override
  Widget build(BuildContext context) {
    int listheight = 39 + 57 * arroption.length;
    return Container(

        margin: EdgeInsets.only(top: 100),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            robotoTextWidget(textval: profilemsg2, colorval: AppColor.black, sizeval: 13.0, fontWeight: FontWeight.normal),

            const SizedBox(height: 17,),
            Container(
              height: listheight.toDouble(),
              child: ListView.builder(
                //controller: _controller,

                itemBuilder: (context, index) {
                  return ListItem(index);
                },
                itemCount: 3,
              ),
            ),
            const SizedBox(height: 40,),
            Container(
              color: AppColor.lightwhite,
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0),

              child: MaterialButton(
                minWidth: double.infinity,
                height: 45,
                onPressed: () {

                  setState(() {

                  });

                },


                child: robotoTextWidget(textval: continuebut, colorval: AppColor.black, sizeval: 17.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],)


    );
  }
  Card ListItem(index) {
    return Card(
        elevation: 1,
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CellRow2(index),
                ])));
  }
  GestureDetector CellRow2(index) {
    return GestureDetector(
        onTap: () {
          setState(() {

          });
          print("Tapped a Container");
        },
        child: Container(
          height: 57,
          decoration: selectedOption == arroption[index]
              ? const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.centerRight,
                colors: [AppColor.white, Colors.lightGreen],
              ))
              : const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10)),
          ),
          child: Center(
            child:

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.start,children: [
                    robotoTextWidget(
                      textval: arroption[index],
                      colorval: AppColor.black,
                      sizeval: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ],

                  ),
                  ),

                  if (arroption[index] == selectedOption)
                    Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end,children: [

                      Icon(
                        Icons.check,
                        color: AppColor.darkGreen,
                        size: 25.0,
                      ),
                    ],

                    ),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                    // Center(
                    //   child: Container(
                    //     margin: const EdgeInsets.only(right: 15),
                    //     child: const Icon(
                    //       Icons.check,
                    //       color: AppColor.darkGreen,
                    //       size: 25.0,
                    //     ),
                    //   ),
                    // ),
                ],
              ),


          ),
        ));
  }
}

class Panel3 extends StatefulWidget {
  // Panel1({required Key key}) : super(key: key);

  @override
  _Panel3State createState() => _Panel3State();
}

class _Panel3State extends State<Panel3> {
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Form(
        key: _formKey,
        child: Container(

            margin: EdgeInsets.only(top: 100),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                robotoTextWidget(textval: profilemsg3, colorval: AppColor.black, sizeval: 13.0, fontWeight: FontWeight.normal),

                const SizedBox(height: 17,),
                TextFormField(
                  //controller: phoneController,
                  keyboardType: TextInputType.phone,
readOnly: true,
                  style: const TextStyle(color: AppColor.black),
                  decoration: const InputDecoration(
                    hintText: "9424880582",
                    hintStyle: TextStyle(color: Colors.black45),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp("^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}")
                            .hasMatch(value)) {
                      return 'Please enter First Name!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  //controller: phoneController,
                  keyboardType: TextInputType.phone,

                  style: const TextStyle(color: AppColor.black),
                  decoration: const InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.black45),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp("^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}")
                            .hasMatch(value)) {
                      return 'Please enter First Name!';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40,),
                Container(
                  color: AppColor.lightwhite,
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20.0),

                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 45,
                    onPressed: () {

                      setState(() {

                      });

                    },


                    child: robotoTextWidget(textval: fnishbut, colorval: AppColor.black, sizeval: 17.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],)


        ));

  }

}