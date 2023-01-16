import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/pref_keys.dart';
import 'injections.dart' as di;
import 'injections.dart';
import 'presentation/custom_widgets/restart_widget.dart';
import 'presentation/screens/companies/companies_screen.dart';
import 'presentation/screens/company_details/company_details_screen.dart';
import 'presentation/screens/main/main_screen.dart';
import 'presentation/screens/search/search_screen.dart';
import 'presentation/screens/single_photo_view/single_photo_view_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(RestartWidget(child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences _prefs;
  String _sharedLang;

  @override
  void initState() {
    super.initState();
    _prefs = serviceLocator<SharedPreferences>();
    _sharedLang = _prefs.get(PrefsKeys.CULTURE_CODE);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Color for Android
        statusBarBrightness:
            Brightness.dark // Dark == white status bar -- for IOS.
        ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Erbil Chamber',
      builder: (context, navigator) {
        var lang = Localizations.localeOf(context).languageCode;

        return Theme(
          data: ThemeData(
              fontFamily: lang == 'en' ? 'Montserrat' : 'NeoSansArabic',
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.indigo,
              appBarTheme: AppBarTheme(
                  backgroundColor: Colors.white,
                  actionsIconTheme: IconThemeData(
                    color: Colors.indigo,
                  ),
                  iconTheme: IconThemeData(
                    color: Colors.black,
                  ))),
          child: navigator,
        );
      },
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
          var view;
          if (settings.name == '/' || settings.name == MainScreen.routeName)
            view = MainScreen();
          else if (settings.name == CompaniesScreen.routeName)
            view = CompaniesScreen(category: settings.arguments);
          else if (settings.name == CompanyDetailsScreen.routeName)
            view = CompanyDetailsScreen(
              companyId: settings.arguments,
            );
          else if (settings.name == SinglePhotoViewScreen.routeName)
            view = SinglePhotoViewScreen(photo: settings.arguments);
          else if (settings.name == SearchScreen.routeName)
            view = SearchScreen(filterOptions: settings.arguments);
          return view;
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.fastOutSlowIn;

          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
      },
      supportedLocales: [
        Locale('en', ''),
        Locale('ar', ''),
        Locale('fa', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (_sharedLang == null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale != null && locale != null) if (supportedLocale
                    .languageCode ==
                locale.languageCode) {
              return supportedLocale;
            }
          }
        } else {
          return Locale(_sharedLang, '');
        }
        return supportedLocales.first;
      },
    );
  }
}
