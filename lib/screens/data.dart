import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/components/routes_manager.dart';
import 'package:flutter_application_shopping/model/model.dart';
import 'package:flutter_application_shopping/utilis/dialogue.dart';

class Data extends StatelessWidget {
  const Data({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
          context,
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome ${user.email} '),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amberAccent,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, Routes.homeRoute);
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
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
                      child: Container(
                        height: 100,
                        color: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: Text(date![index]),
                              ),
                              SizedBox(
                                child: Text(from![index]),
                              ),
                              SizedBox(
                                child: Text(to![index]),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: Text(status![index]),
                              )
                            ],
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
      ),
    );
  }

  Stream<List<Users>> readUsers() => FirebaseFirestore.instance
      .collection('users data')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Users.fromJson(doc.data())).toList());
}
