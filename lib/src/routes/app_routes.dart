import 'package:flutter/material.dart';
import 'package:launcher/src/screens/screens.dart';
import 'package:launcher/src/utilities/routeAnimatior.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Home.route:
        return MaterialPageRoute(builder: (_) => Home());

      case AppDrawer.route:
        return RouteAnimator.createRoute(AppDrawer());

      default:
        return MaterialPageRoute(
            builder: (_) =>
                Page404(errorMessage: "Could not find route ${settings.name}"));
    }
  }
}
