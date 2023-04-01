import 'dart:async';
import 'dart:developer';
import 'package:dainik_ujala/UI%20Components/themes.dart';
import 'package:dainik_ujala/Views/main_page.dart';
import 'package:dainik_ujala/Views/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Backend/providers.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  log("Handling a background message: ${message.messageId}");
}


final _messageStreamController = BehaviorSubject<RemoteMessage>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Step 1 [Reuest Permission]
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    log('Permission granted: ${settings.authorizationStatus}');
  }

  /// Step 2 [Register with FCM]
  // It requests a registration token for sending messages to users from your App server or other trusted server environment.
  String? token = await messaging.getToken();

  if (kDebugMode) {
    log('Registration Token=$token');
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Got a message whilst in the foreground!');
    log('Message data: ${message.data}');

    if (message.notification != null) {
      log('Message also contained a notification: ${message.notification}');
    }
  });

  /// Step 3 [Set up foreground message handler]

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
      print('Message notification: ${message.notification?.body}');
    }

    _messageStreamController.sink.add(message);
  });

  /// Step 4 [Set up background message handler]
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
          theme: value.isDark ? MyThemes.lightTheme : MyThemes.darkTheme,
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
    return const SplashScreen();
  }
}
