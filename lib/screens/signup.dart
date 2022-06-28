import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/components/routes_manager.dart';
import 'package:flutter_application_shopping/constants/colors.dart';
import 'package:flutter_application_shopping/constants/textfieldDecoration.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  var focusNode = FocusNode();
  var unusedFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
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
            Container(
              margin: EdgeInsets.only(top: size.height / 26),
              child: Text("Sign Up",
                  style: TextStyle(
                      fontSize: size.height / 38.5,
                      fontFamily: "Open",
                      fontWeight: FontWeight.w600,
                      color: incomingCallerNameColor)),
            ),
            Container(
              margin: EdgeInsets.only(top: size.height / 32),
              height: size.height / 17,
              width: size.width / 1.2,
              child: TextField(
                autofocus: false,
                controller: emailcontroller,
                // keyboardType: TextInputType.emailAddress,
                onSubmitted: (value) {
                  FocusScope.of(context).requestFocus(focusNode);
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
                focusNode: focusNode,
                autofocus: false,
                obscureText: isPasswordVisible,
                controller: passcontroller,
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
            Row(
              children: const [],
            ),
            GestureDetector(
              onTap: () {
                print('tappp');
                print(emailcontroller.text);
                signup();
                print(signup());
              },
              child: Container(
                margin: EdgeInsets.only(top: size.height / 25),
                height: size.height / 17,
                width: size.width / 1.2,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: borderColor, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(28))),
                child: Center(
                  child: loading == false
                      ? Text("Sign Up",
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
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? '),
                GestureDetector(
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Routes.loginRoute);
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

  Future<bool> signup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailcontroller.text, password: passcontroller.text);
      Navigator.pushReplacementNamed(context, Routes.home);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }
}
