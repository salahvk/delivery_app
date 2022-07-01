import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  bool _isPasswordVisible = false;
  String email = "";
  String password = "";
  bool loading = false;
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
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
                controller: emailcontroller,
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
                  hintText: "Email",
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
                obscureText: !_isPasswordVisible,
                controller: passcontroller,
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
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
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
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                onsubmitted();
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

  Future onsubmitted() async {
    email = emailcontroller.text.trim();
    password = passcontroller.text.trim();
    print(email);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    print('$emailValid emailValid');

    if (email.isEmpty || email.length < 4 || emailValid != true) {
      Fluttertoast.showToast(
          msg: "Enter a valid Email",
          textColor: Colors.white,
          backgroundColor: Colors.grey,
          gravity: ToastGravity.CENTER);
    } else if (password.isEmpty || password.length < 6) {
      Fluttertoast.showToast(
          msg: "Password must be 6 Characters",
          textColor: Colors.white,
          backgroundColor: Colors.grey,
          gravity: ToastGravity.CENTER);
    } else {
      setState(() {
        loading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailcontroller.text, password: passcontroller.text);
        print('Sign in');
        Navigator.pushReplacementNamed(context, Routes.data);
      } on FirebaseAuthException catch (e) {
        print(e.code);
        print(e.message);
        if (e.code == 'wrong-password') {
          // print(
          //     'The password is invalid or the user does not have a password.');
          Fluttertoast.showToast(
              msg: "The password is invalid",
              textColor: Colors.white,
              backgroundColor: Colors.grey,
              gravity: ToastGravity.CENTER);
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        } else if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
              msg: "There is no user in this name",
              textColor: Colors.white,
              backgroundColor: Colors.grey,
              gravity: ToastGravity.CENTER);
        } else if (e.code == 'too-many-requests') {
          Fluttertoast.showToast(
              msg: "Too many requests.Try again later",
              textColor: Colors.white,
              backgroundColor: Colors.grey,
              gravity: ToastGravity.CENTER);
        } else if (e.code == 'network-request-failed') {
          Fluttertoast.showToast(
              msg: "interrupted connection ! Please check your network",
              textColor: Colors.white,
              backgroundColor: Colors.grey,
              gravity: ToastGravity.CENTER);
        } else if (e.code == 'unknown') {
          Fluttertoast.showToast(
              msg: "Please check your connection",
              textColor: Colors.white,
              backgroundColor: Colors.grey,
              gravity: ToastGravity.CENTER);
        }
        setState(() {
          loading = false;
        });
        // Fluttertoast.showToast(
        //     msg: "SomeThing Wrong",
        //     textColor: Colors.white,
        //     backgroundColor: Colors.grey,
        //     gravity: ToastGravity.CENTER);
        // print(e);
      }
    }
  }
}
