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
  bool isPasswordVisible = false;
  String email = "";
  String password = "";
  bool loading = false;
  final snackBar = const SnackBar(
    content: Text('Account Created!'),
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void setPsswordVisibility() {
      setState(() {
        isPasswordVisible = !isPasswordVisible;
      });
    }

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
                autofocus: false,
                obscureText: !isPasswordVisible,
                controller: passcontroller,
                onSubmitted: (value) {},
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
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setPsswordVisibility();
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
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailcontroller.text, password: passcontroller.text);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print('successsssssssss');
        Navigator.pushReplacementNamed(context, Routes.loginRoute);
        loading = false;
      } on FirebaseAuthException catch (e) {
        setState(() {
          loading = false;
        });
        print(e.code);
        if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: "The email address is already in use by another account",
              textColor: Colors.white,
              backgroundColor: Colors.grey,
              gravity: ToastGravity.CENTER);
        }
        // Fluttertoast.showToast(
        //     msg: "SomeThing Wrong",
        //     textColor: Colors.white,
        //     backgroundColor: Colors.grey,
        //     gravity: ToastGravity.CENTER);
        print(e.message);
      }
    }
  }
}
