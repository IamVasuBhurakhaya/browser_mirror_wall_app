import 'package:browser_mirror_wall_app/screens/view/screen/home_screen.dart';
import 'package:flutter/cupertino.dart';

class MyRoutes {
  static String homePage = '/';
  static String webPage = 'web_page';

  static Map<String, WidgetBuilder> routes = {
    homePage: (context) => HomePage(),
  };
}
