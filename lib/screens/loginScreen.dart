import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/constants/colors.dart';
import 'package:flutter_application_shopping/constants/textfieldDecoration.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/routes_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // var focusNode = FocusNode();
    bool isPasswordVisible = true;
    String email = "";
    String password = "";
    bool loading = false;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: size.height / 15, left: size.height / 26),
                  child: Text("Sign In",
                      style: TextStyle(
                          fontSize: size.height / 38.5,
                          fontFamily: "Open",
                          fontWeight: FontWeight.w600,
                          color: incomingCallerNameColor)),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: size.height / 20),
              height: size.height / 17,
              width: size.width / 1.2,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (value) {
                  // FocusScope.of(context).requestFocus(focusNode);
                },
                onChanged: (value) {},
                style: TextStyle(
                    color: readRowTextColor,
                    fontFamily: "Open",
                    fontWeight: FontWeight.w600,
                    fontSize: size.height / 54),
                decoration: searchBoxDecoration.copyWith(
                  hintText: "Username",
                ),
                cursorColor: readRowTextColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height / 30),
              height: size.height / 17,
              width: size.width / 1.2,
              child: TextField(
                // focusNode: focusNode,
                obscureText: isPasswordVisible,
                onSubmitted: (value) {
                  if (email.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Enter Username",
                        textColor: Colors.white,
                        backgroundColor: Colors.grey,
                        gravity: ToastGravity.CENTER);
                    // _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Enter Username")));
                  } else if (password.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Enter Password",
                        textColor: Colors.white,
                        backgroundColor: Colors.grey,
                        gravity: ToastGravity.CENTER);
                    // _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Enter Password")));
                  } else {
                    setState(() {
                      loading = true;
                    });
                  }
                },
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                style: TextStyle(
                    color: readRowTextColor,
                    fontFamily: "Open",
                    fontWeight: FontWeight.w600,
                    fontSize: size.height / 54),
                decoration: searchBoxDecoration.copyWith(
                  hintText: "Password",
                  suffixIcon: IconButton(
                      icon: Icon(!isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      }),
                ),
                cursorColor: readRowTextColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height / 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [Text('Remember Me'), Text('Forgot Password')],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height / 25),
              height: size.height / 17,
              width: size.width / 1.2,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(color: borderColor, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(28))),
              child: Center(
                child: loading == false
                    ? Text("Sign In",
                        style: TextStyle(
                            fontSize: size.height / 51,
                            fontFamily: "Open",
                            fontWeight: FontWeight.w600,
                            color: Colors.white))
                    : Container(
                        child: const CircularProgressIndicator(
                          backgroundColor: fabColor,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dont have an account? '),
                GestureDetector(
                  child: const Text(
                    'Create new one',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Routes.signUpRoute);
                  },
                )
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      )),
    );
  }
}
