import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mne_app/src/core/ui/page_transition_rtl.dart';
import 'package:mne_app/src/core/utils/constants.dart';
import 'package:mne_app/src/features/AddEditEntry/presentation/pages/add_edit_entry.dart';
import 'package:mne_app/src/features/Auth/presentation/pages/login.dart';
import 'package:mne_app/src/features/Entries/presentation/pages/entries.dart';
import 'package:mne_app/src/features/Home/presentation/pages/home.dart';
import 'package:mne_app/src/features/Menu/presentation/pages/menu.dart';
import 'package:mne_app/src/features/Profile/presentation/pages/profile.dart';
import 'package:mne_app/src/features/Reports/presentation/pages/reports.dart';

import 'features/About/presentation/pages/about.dart';
import 'features/Auth/presentation/pages/auth.dart';
import 'features/Help/presentation/pages/help.dart';
import 'features/Splash/presentation/pages/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      theme: ThemeData(),
      onGenerateRoute: (RouteSettings routeSettings) {
        switch (routeSettings.name) {
          case Routes.SPLASH:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const SplashScreen(),
            );
          case Routes.AUTH:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const AuthScreen(),
            );
          case Routes.LOGIN:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const LoginScreen(),
            );
          case Routes.MENU:
            return PageTransitionRTL(
              settings: routeSettings,
              page: const MenuScreen(),
            );
          case Routes.HOME:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const HomeScreen(),
            );
          case Routes.MY_ENTRIES:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const MyEntriesScreen(),
            );
          case Routes.REPORTS:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const ReportsScreen(),
            );
          case Routes.NEW_ENTRY:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const AddEditEntryScreen(),
            );
          case Routes.EDIT_ENTRY:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const AddEditEntryScreen(),
            );
          case Routes.VIEW_ENTRY:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const AddEditEntryScreen(),
            );
          case Routes.PROFILE:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const ProfileScreen(),
            );
          case Routes.HELP:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const HelpScreen(),
            );
          case Routes.ABOUT:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const AboutScreen(),
            );
          default:
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (_) => const SplashScreen(),
            );
        }
      },
      initialRoute: Routes.SPLASH,
    );
  }
}
