import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/components/routes_manager.dart';
import 'package:flutter_application_shopping/model/model.dart';
import 'package:flutter_application_shopping/utilis/dialogue.dart';

import '../animation/animation.dart';

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final size = MediaQuery.of(context).size;

    List<String> statusList = ['Pending', 'Delivered', 'Not Delivered'];
    String? selectedStatus = '';
    String hint = 'Select item';
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user.email} '),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, Routes.homeRoute);
                },
                child: const Text('Log out')),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.dataEntry);
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Users>>(
        stream: readUsers(),
        builder: (contexts, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data;

            //! declaration

            List<String>? date = users?.map(((e) {
              return e.userDate;
            })).toList();
            List<String>? from = users?.map(((e) {
              return e.from;
            })).toList();
            List<String>? to = users?.map(((e) {
              return e.to;
            })).toList();
            List<String>? status = users?.map(((e) {
              return e.status;
            })).toList();
            List<String>? id = users?.map(((e) {
              return e.id;
            })).toList();
            int? len = date?.length;

            //! declaration

            //users!.map(buildUser).toList(),
            return ListView.builder(
              itemBuilder: (context, index) {
                return FadeCustomAnimation(
                  delay: 0.001,
                  child: InkWell(
                    onLongPress: () {
                      print('hello');
                      print(id);

                      showDialog(
                          context: context,
                          builder: (context) => DialogueBox(
                                id: id![index],
                              ),
                          barrierDismissible: false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                      child: Container(
                        height: size.height / 10,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width / 7.8,
                                height: size.height / 10,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)),
                                child: Center(child: Text(date![index])),
                              ),
                              Container(
                                width: size.width / 4.3,
                                height: size.height / 10,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)),
                                child: Center(
                                    child: SingleChildScrollView(
                                        child: Text(from![index]))),
                              ),
                              Container(
                                width: size.width / 4.3,
                                height: size.height / 10,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)),
                                child: Center(
                                    child: SingleChildScrollView(
                                        child: Text(to![index]))),
                              ),
                              Center(
                                child: Container(
                                  width: size.width / 3.4,
                                  height: size.height / 10,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.orange),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(6, 0, 0, 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              value: status![index],
                                              dropdownMaxHeight:
                                                  size.height * .3,
                                              isExpanded: true,
                                              hint: Text(hint),
                                              dropdownWidth: size.width / 3.5,
                                              disabledHint: Text(hint),
                                              items: statusList
                                                  .map(
                                                    (e) => DropdownMenuItem<
                                                        String>(
                                                      value: e,
                                                      child: Text(e),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (v) {
                                                setState(() {
                                                  if (v != null) {
                                                    selectedStatus = v;
                                                    print(selectedStatus);
                                                    print(id![index]);
                                                    final docuser =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'users data')
                                                            .doc(id[index]);
                                                    docuser.update({
                                                      'status':
                                                          '$selectedStatus'
                                                    });
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: len,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Stream<List<Users>> readUsers() => FirebaseFirestore.instance
      .collection('users data')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());
}
