import 'package:browser_mirror_wall_app/routes/app_routes.dart';
import 'package:browser_mirror_wall_app/screens/view/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, value, Widget? child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: HomeProvider()),
          ],
          child: Consumer<HomeProvider>(
            builder: (BuildContext context, value, Widget? child) {
              value.getThemeMode();
              return MaterialApp(
                theme: value.isDark ? ThemeData.dark() : ThemeData.light(),
                // themeMode: ThemeMode.dark,
                debugShowCheckedModeBanner: false,
                routes: MyRoutes.routes,
              );
            },
          ),
        );
      },
    );
  }
}
