import 'dart:async';
import 'dart:developer';
import 'package:dainik_ujala/UI%20Components/themes.dart';
import 'package:dainik_ujala/Views/main_page.dart';
import 'package:dainik_ujala/Views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Backend/providers.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A Background message just showed up :  ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// Firebase local notification plugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

//Firebase messaging
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
          debugPrint("Initial URI received ${initialURI.toString()}");
          if (!mounted) {
            return;
          }
          setState(() {});
        } else {
          debugPrint("Null Initial URI received");
        }

        goAway(initialURI);
      } on PlatformException {
        // 5
        debugPrint("Failed to receive initial uri");
      } on FormatException catch (err) {
        debugPrint(err.message);
        // 6
        if (!mounted) {
          return;
        }
        debugPrint('Malformed Initial URI received');
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.white,
                playSound: true,
                icon: '@mipmap/ic_lancher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new messageopen app event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        haveToHandleURL = false;
        goAway(Uri.parse(message.data['url']));
        log(message.toMap().toString());
      }
    });
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
