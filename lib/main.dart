import 'package:epanty_mobility/localisation.dart';
import 'package:epanty_mobility/views/Home/home_screen.dart';
import 'package:epanty_mobility/views/authentication/authPage.dart';
import 'package:epanty_mobility/views/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:epanty_mobility/views/Splashsceen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:epanty_mobility/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

bool? seenOnboard;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await initializeService();
  // to load onboard for the first time only
  SharedPreferences pref = await SharedPreferences.getInstance();
  seenOnboard = pref.getBool('seenOnboard') ?? false; //if null set to false

  await Firebase.initializeApp();

  runApp(MyApp());
}

/*Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

void onStart(ServiceInstance service) {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}*/
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences prefs;
  Locale _locale = Locale('es');

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  void myAppInitFunction(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    String? locale = "es";
    locale = prefs.getString('locale')?? "";
    switch (locale){
      case 'English': {
        _locale = Locale('en');
      }
      break;

      case 'French': {
        _locale = Locale('fr');
      }
      break;

      case 'Default': {
        _locale = Locale('');
      }
      break;
    }
    if (locale == 'en' || locale == 'fr') {
      _locale = Locale(locale);
      setLocale(_locale);
    }
  }

  @override
  void initState() {
    myAppInitFunction(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale == Locale('es') ? null : _locale,
      supportedLocales: [
        Locale('en', ''), //
        Locale('fr', ''), //
      ],
      debugShowCheckedModeBanner: false,
      title: 'epanty_mobility',
      theme: ThemeData(
        textTheme: GoogleFonts.manropeTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: kScaffoldBackground,
      ),
      home: seenOnboard == true ? SplashScreenWrapper() : OnBoardingPage(),
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  @override
  State<SplashScreenWrapper> createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, initialisationSnapshot) {
        // If Firebase App init, snapshot has error
        /// Checking if an error occurred during the Initialisation of the Firebase instance in the app
        if (initialisationSnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${initialisationSnapshot.error}"),
            ),
          );
        }

        /// Checking if Initialisation of the Firebase instance in the app was successful
        if (initialisationSnapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            /// Creating an instance of a stream from firebase that provides us with info about the login state of the user in the app.
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authStreamSnapshot) {
              /// Checking if an error occurred during the Instantiation of the Firebase authenticationState stream instance
              if (authStreamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${authStreamSnapshot.error}"),
                  ),
                );
              }

              /// Checking if Instantiation of the Firebase authenticationState stream instance was successful
              if (authStreamSnapshot.connectionState ==
                  ConnectionState.active) {
                // Get the user
                ///Retrieving the user's authentication state from authenticationState stream
                User? _user = authStreamSnapshot.data as User?;

                /// Checking if there is no user logged in
                if (_user == null) {
                  // user not logged in, head to login
                  return  AuthPage();
                }

                /// Checking if there is a user logged in
                else {
                  return HomeScreen();
                }
              }

              /// Screen displayed while Creating the authenticationState stream and checking the user's login state.
              return Container();
            },
          );
        }
        /// Screen displayed while Initializing the Firebase instance in the app
        return Container();
      },
    );
  }
}
