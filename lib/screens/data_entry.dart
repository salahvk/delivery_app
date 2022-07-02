import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/components/routes_manager.dart';
import 'package:flutter_application_shopping/constants/colors.dart';
import 'package:flutter_application_shopping/constants/textfieldDecoration.dart';
import 'package:flutter_application_shopping/model/model.dart';
import 'package:flutter_application_shopping/utilis/snackbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

class DataEntry extends StatefulWidget {
  const DataEntry({Key? key}) : super(key: key);

  @override
  State<DataEntry> createState() => _LoginPageState();
}

class _LoginPageState extends State<DataEntry> {
  TextEditingController statuscontroller = TextEditingController();
  TextEditingController tocontroller = TextEditingController();
  TextEditingController fromcontroller = TextEditingController();
  String from = "";
  String to = "";
  String status = "";
  String date = "";

  bool loading = false;

  var focusNode = FocusNode();

  DateTime selectedDate = DateTime.now();
  List<String> statusList = ['Pending', 'Delivered', 'Not Delivered'];
  String? selectedStatus = '';
  String hint = 'Select item';

  String formattedDate = '';

  bool hasInternet = false;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedStatus = 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var formatter = DateFormat('dd-MM-yyyy');
    formattedDate = formatter.format(selectedDate);

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
                    child: Center(child: Text(formattedDate)),
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
                  decoration: BoxDecoration(
                    border: Border.all(color: readRowTextColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              value: selectedStatus,
                              dropdownMaxHeight: size.height * .3,
                              isExpanded: true,
                              hint: Text(hint),
                              disabledHint: Text(hint),
                              items: statusList
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                setState(() {
                                  if (v != null) {
                                    selectedStatus = v;
                                  } else {
                                    selectedStatus = hint;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                    hasInternet =
                        await InternetConnectionChecker().hasConnection;
                    if (hasInternet == false) {
                      setState(() {
                        loading = false;
                      });
                      // ignore: use_build_context_synchronously
                      showSnackBar("No connection!", context,
                          icon: Icons
                              .signal_cellular_connected_no_internet_0_bar_sharp,
                          color: Colors.red);
                    }

                    hasInternet
                        ? onSubmitted()
                        // ignore: use_build_context_synchronously
                        : showSnackBar("No connection!", context,
                            icon: Icons
                                .signal_cellular_connected_no_internet_0_bar_sharp,
                            color: Colors.red);
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
    status = selectedStatus!;

    if (from.isEmpty || to.isEmpty || status.isEmpty) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: "Complete the required fields",
          textColor: Colors.white,
          backgroundColor: Colors.grey,
          gravity: ToastGravity.CENTER);
      return;
    } else {
      final docUser = FirebaseFirestore.instance.collection('users data').doc();
      final user = Users(
          id: docUser.id,
          userDate: formattedDate,
          from: from,
          to: to,
          status: status);

      final json = user.tojson();

      try {
        await docUser.set(json);

        // ignore: use_build_context_synchronously
        showSnackBar("Data entered!", context,
            icon: Icons.data_saver_on_rounded);
        setState(() {
          loading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, Routes.data);
      } on Exception {
        print('object');
      }
    }
  }
}
