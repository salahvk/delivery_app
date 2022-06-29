import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlaceMenu extends StatefulWidget {
  const PlaceMenu({Key? key}) : super(key: key);

  @override
  State<PlaceMenu> createState() => _HomeState();
}

class _HomeState extends State<PlaceMenu> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        body: Center(
      child: Text('${user.email}Entered'),
    ));
  }
}
