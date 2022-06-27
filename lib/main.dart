import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:provider/provider.dart';
import 'package:trail/models/game_model.dart';
import 'package:trail/utils/resources.dart';
import 'package:trail/views/pages/game_page.dart';
import 'package:trail/views/pages/levels_page.dart';
import 'package:trail/views/pages/splash_page.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) {
      return GameModel();
    })
  ], child: const Trail()));
}

class Trail extends StatelessWidget {
  const Trail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Trail',
        onGenerateRoute: (settings) => createRoute(settings),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Overpass',
          scaffoldBackgroundColor: Resources.main,
        ),
        home: const SplashPage());
  }
}

Route<dynamic>? createRoute(RouteSettings settings) {
  Widget? page;
  switch (settings.name) {
    case '/game':
      Map<String, dynamic>? args;
      try {
        args = (settings.arguments as Map<String, dynamic>?);
      } catch(ignore) {args = null;}
      page = GamePage(
        level: args?['level'] ?? 0,
        redraw: args?['redraw'] ?? true,
      );
      break;
    case '/levels':
      Map<String, dynamic>? args;
      try {
        args = (settings.arguments as Map<String, dynamic>?);
      } catch(ignore) {args = null;}
      page = LevelsPage(
        current: args?['current'] ?? 0,
      );
      break;
  }
  if (page == null) return null;
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page!,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
