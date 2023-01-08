import 'dart:async';
import 'package:dainik_ujala/UI%20Components/themes.dart';
import 'package:dainik_ujala/Views/main_page.dart';
import 'package:dainik_ujala/Views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

Future<void> main() async {
  runApp(const MyApp());
}

bool _initialURILinkHandled = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
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

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        // 3
        final initialURI = await getInitialUri();
        // 4
        if (initialURI.toString().toLowerCase() ==
            "https://dainikujala.live/" && initialURI.toString().toLowerCase() == "https://dainikujala.live" ) {
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
            builder: (context) => SplashScreen(
                  initialURI: uri,
                )));
  }

  @override
  void initState() {
    super.initState();
    _initURIHandler();
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
