import 'package:flutter/cupertino.dart';

import 'screens/home_screen.dart';
import 'app_theme.dart';

class StaylyApp extends StatelessWidget {
  const StaylyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Stayly',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        primaryColor: coral,
        scaffoldBackgroundColor: pageBackground,
        barBackgroundColor: pageBackground,
        textTheme: CupertinoTextThemeData(
          navTitleTextStyle: TextStyle(
            inherit: false,
            color: ink,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}