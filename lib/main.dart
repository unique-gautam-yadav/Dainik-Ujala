import 'dart:async';
import 'dart:developer';
import 'package:dainik_ujala/UI%20Components/themes.dart';
import 'package:dainik_ujala/Views/main_page.dart';
import 'package:dainik_ujala/Views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Backend/providers.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('A Background message just showed up :  ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

bool _initialURILinkHandled = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(builder: (context, value, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: value.isDark
              ? MyThemes.lightTheme
              : ThemeData(
                  appBarTheme: AppBarTheme(
                    backgroundColor: Colors.grey.shade300.withOpacity(0.6),
                    foregroundColor: Colors.black,
                  ),
                  tabBarTheme: TabBarTheme(
                    indicatorColor: Colors.deepOrange,
                    labelColor: Colors.deepOrange.shade800,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelColor: Colors.black,
                  ),
                  brightness: Brightness.dark,
                  useMaterial3: true,
                  colorSchemeSeed: const Color(0x00FF7722),
                  fontFamily: GoogleFonts.lato().toString(),
                  scaffoldBackgroundColor:
                      const Color.fromARGB(255, 20, 27, 30),
                  cardColor: const Color.fromARGB(255, 0, 12, 6),
                  bottomSheetTheme: const BottomSheetThemeData(
                      backgroundColor: Color.fromARGB(255, 20, 27, 30),
                      elevation: 0),
                ),
          debugShowCheckedModeBanner: false,
          home: const MainScreen(),
        );
      }),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  StreamSubscription? _streamSubscription;

  bool haveToHandleURL = true;

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        // 3
        final initialURI = await getInitialUri();
        // 4
        if (initialURI.toString().toLowerCase() ==
                "https://dainikujala.live/" &&
            initialURI.toString().toLowerCase() == "https://dainikujala.live") {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ));
        }
        if (initialURI != null) {
          log("Initial URI received ${initialURI.toString()}");
          if (!mounted) {
            return;
          }
          setState(() {});
        } else {
          log("Null Initial URI received");
        }

        goAway(initialURI);
      } on PlatformException {
        // 5
        log("Failed to receive initial uri");
      } on FormatException catch (err) {
        log(err.message);
        // 6
        if (!mounted) {
          return;
        }
        log('Malformed Initial URI received');
      }
    }
  }

  goAway(Uri? uri) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SplashScreen(initialURI: uri),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (haveToHandleURL) {
      _initURIHandler();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
