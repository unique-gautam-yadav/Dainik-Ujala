import 'dart:async';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dainik_ujala/Backend/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Backend/promotions.dart';
import 'Backend/providers.dart';
import 'UI%20Components/themes.dart';
import 'Views/main_page.dart';
import 'Views/redirected_screen.dart';
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
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'noti',
        channelName: 'Notifications Channel',
        channelDescription: 'Channel which will be used for notifications',
        defaultColor: Colors.deepOrange.shade700,
        ledColor: Colors.white,
        importance: NotificationImportance.Max,
        defaultRingtoneType: DefaultRingtoneType.Notification,
      )
    ],
    debug: false,
  );

  FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.subscribeToTopic("news");
  FirebaseMessaging.instance.subscribeToTopic("media");
  FirebaseMessaging.instance.subscribeToTopic("version2-1");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PromotionsProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

bool _initialURILinkHandled = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            theme: value.isDark ? MyThemes.lightTheme : MyThemes.darkTheme,
            debugShowCheckedModeBanner: false,
            home: const MainScreen(),
          );
        },
      ),
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
    if (uri != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RedirectedPage(initialURI: uri),
        ),
      );
    }
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
            builder: (_) => RedirectedPage(
              initialURI: uri,
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const TempLoading();
  }
}

class TempLoading extends StatefulWidget {
  const TempLoading({super.key});

  @override
  State<TempLoading> createState() => _TempLoadingState();
}

class _TempLoadingState extends State<TempLoading> {
  fetchAdvts() async {
    List<AdvtModel> d = await Promotions().getPromotions();
    if (context.mounted) {
      Provider.of<PromotionsProvider>(context, listen: false).setPromotions(d);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchAdvts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitRotatingCircle(
            color: Colors.deepOrange,
            size: 75,
          ),
          SizedBox(height: 5),
          Text("Loading..."),
        ],
      ),
    );
  }
}
