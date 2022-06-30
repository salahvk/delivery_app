import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/screens/data.dart';
import 'package:flutter_application_shopping/screens/data_entry.dart';
import 'package:flutter_application_shopping/screens/home.dart';
import 'package:flutter_application_shopping/screens/place_menu.dart';
import 'package:flutter_application_shopping/screens/sign_in.dart';
import 'package:flutter_application_shopping/screens/splash_screen.dart';

import '../screens/sign_up.dart';

class Routes {
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String signUpRoute = '/SignUp';
  static const String placeMenu = '/PlaceMenu';
  static const String data = '/data';
  static const String dataEntry = '/dataEntry';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const Splash());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const Home());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case Routes.placeMenu:
        return MaterialPageRoute(builder: (_) => const PlaceMenu());
      case Routes.data:
        return MaterialPageRoute(builder: (_) => const Data());
      case Routes.dataEntry:
        return MaterialPageRoute(builder: (_) => const DataEntry());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("No Route Found"),
        ),
        body: const Center(
          child: Text("No Route Found"),
        ),
      ),
    );
  }
}
