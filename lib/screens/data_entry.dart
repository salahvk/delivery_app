import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/components/routes_manager.dart';
import 'package:flutter_application_shopping/constants/colors.dart';
import 'package:flutter_application_shopping/constants/textfieldDecoration.dart';
import 'package:flutter_application_shopping/model/model.dart';

class DataEntry extends StatefulWidget {
  const DataEntry({Key? key}) : super(key: key);

  @override
  State<DataEntry> createState() => _LoginPageState();
}

class _LoginPageState extends State<DataEntry> {
  TextEditingController statuscontroller = TextEditingController();
  TextEditingController tocontroller = TextEditingController();
  TextEditingController fromcontroller = TextEditingController();
  final snackBar = const SnackBar(
    content: Text('Data entered!'),
  );
  String from = "";
  String to = "";
  String status = "";
  String date = "";
  bool loading = false;
  var focusNode = FocusNode();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    date = "${selectedDate.toLocal()}".split(' ')[0];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: size.height / 15, left: size.height / 26),
                      child: Text("Enter data",
                          style: TextStyle(
                              fontSize: size.height / 38.5,
                              fontFamily: "Open",
                              fontWeight: FontWeight.w600,
                              color: incomingCallerNameColor)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  child: Container(
                    width: 160,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 233, 220, 220),
                        border: Border.all(color: Colors.black)),
                    child: Center(child: Text(date)),
                  ),
                  onTap: () {
                    _selectDate(context);
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height / 20),
                  height: size.height / 17,
                  width: size.width / 1.2,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: fromcontroller,
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
                      hintText: "from",
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
                    controller: tocontroller,
                    onChanged: (value) {},
                    style: TextStyle(
                        color: readRowTextColor,
                        fontFamily: "Open",
                        fontWeight: FontWeight.w600,
                        fontSize: size.height / 54),
                    decoration: searchBoxDecoration.copyWith(
                      hintText: "To",
                    ),
                    cursorColor: readRowTextColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height / 20),
                  height: size.height / 17,
                  width: size.width / 1.2,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: statuscontroller,
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
                      hintText: "Status",
                    ),
                    cursorColor: readRowTextColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: size.height / 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    onSubmitted();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: size.height / 25),
                    height: size.height / 17,
                    width: size.width / 1.2,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(color: borderColor, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(28))),
                    child: Center(
                      child: loading == false
                          ? Text("Create",
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future onSubmitted() async {
    from = fromcontroller.text;
    to = tocontroller.text;
    status = statuscontroller.text;

    final docUser = FirebaseFirestore.instance.collection('users data').doc();
    final user = Users(
        id: docUser.id, userDate: date, from: from, to: to, status: status);

    final json = user.tojson();
    await docUser.set(json);
    print('success');
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setState(() {
      loading = false;
    });
    Navigator.pushReplacementNamed(context, Routes.data);
  }
}
