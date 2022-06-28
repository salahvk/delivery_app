import 'package:flutter/material.dart';
import 'package:flutter_application_shopping/screens/homepage.dart';
import 'package:flutter_application_shopping/screens/loginScreen.dart';
import 'package:flutter_application_shopping/screens/splash_screen.dart';

import '../screens/signup.dart';

class Routes {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String signUpRoute = '/SignUp';
  static const String home = '/Home';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const Splash());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const Home());

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
