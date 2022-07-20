import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../theme/responsive.dart';
import '../web_service/Constant.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  bool _passwordVisible = true;
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(LoginID, "1");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => MainEntryPoint()),
            (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Responsive.isXS(context)
                ? AssetImage(mobileLoginBackGround)
                : AssetImage(loginPageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          // Vertically center the widget inside the column
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              width: MediaQuery.of(context).size.width > 400
                  ? 400
                  : MediaQuery.of(context).size.width,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(.5),
                  blurRadius: 20.0, // soften the shadow
                )
              ]),
              child: isLoading
                  ? const Center(child: const CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                  hintText: "Please enter phone number",
                                  hintStyle: TextStyle(color: Colors.black38),
                                  icon: Icon(Icons.phone_android)),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp("^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}")
                                        .hasMatch(value)) {
                                  return 'Please enter valid phone number!';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              style: const TextStyle(color: Colors.black),
                              obscureText: _passwordVisible,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Password';
                                }
                                   return null;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: "Please enter Password",
                                hintStyle: const TextStyle(color: Colors.black38),
                                icon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    //change icon based on boolean value
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible =
                                          !_passwordVisible; //change boolean value
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40.0,
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              margin: const EdgeInsets.only(top: 30.0),
                              child: MaterialButton(
                                minWidth: double.infinity,
                                height: 45,
                                onPressed: () {
                                  _submit();
                                },
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.teal,
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Forgot Password',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
