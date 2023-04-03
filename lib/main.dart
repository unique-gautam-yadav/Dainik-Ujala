import 'dart:async';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import 'Backend/providers.dart';
import 'UI%20Components/themes.dart';
import 'Views/main_page.dart';
import 'Views/splash_screen.dart';
import 'firebase_options.dart';

Future<void> handleBackgroundNotification(RemoteMessage message) async {
  String? title = message.notification!.title;
  String? body = message.notification!.body;
  String? image = message.data['imgUrl'];
  String? newsUrl = message.data['url'];

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 01,
      channelKey: 'noti',
      title: title,
      body: body,
      wakeUpScreen: true,
      notificationLayout: image != null
          ? NotificationLayout.BigPicture
          : NotificationLayout.Default,
    ),
  );
  AwesomeNotifications().actionStream.listen((event) {
    // Uri? uri = Uri.tryParse(newsUrl ?? "");
    log("have to listen about $newsUrl");
    //
  });
}

void main() async {
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'noti',
      channelName: 'Notifications Channel',
      channelDescription: 'Channel which will be used for notifications',
      defaultColor: Colors.deepOrange.shade700,
      ledColor: Colors.white,
      importance: NotificationImportance.Max,
      defaultRingtoneType: DefaultRingtoneType.Notification,
    )
  ]);

  FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.subscribeToTopic("news");
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
          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
          }
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
    FirebaseMessaging.onMessage.listen((message) {
      String? title = message.notification!.title;
      String? body = message.notification!.body;
      String? image = message.data['imgUrl'];
      String? newsUrl = message.data['url'];

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 01,
          channelKey: 'noti',
          title: title,
          body: body,
          wakeUpScreen: true,
          notificationLayout: image != null
              ? NotificationLayout.BigPicture
              : NotificationLayout.Default,
          bigPicture: image,
        ),
      );
      AwesomeNotifications().actionStream.listen((event) {
        Uri? uri = Uri.tryParse(newsUrl ?? "");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SplashScreen(
              initialURI: uri,
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
