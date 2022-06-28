import 'dart:async';
import 'package:flutter/material.dart';
import '../components/assets_manager.dart';
import '../components/routes_manager.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer? timer;

  _startDelay() {
    timer = Timer(const Duration(seconds: 2), _goNextPage);
  }

  _goNextPage() async {
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ImageAssets.logo, fit: BoxFit.scaleDown),
      ),
    );
  }
}
