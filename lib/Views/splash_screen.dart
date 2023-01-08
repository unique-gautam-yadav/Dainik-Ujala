// ignore_for_file: use_build_context_synchronously

import 'package:dainik_ujala/Views/main_page.dart';
import 'package:dainik_ujala/Views/redirected_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'no_internet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.initialURI});
  final Uri? initialURI;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) async {
      ConnectivityResult res = await Connectivity().checkConnectivity();
      if (res == ConnectivityResult.mobile ||
          res == ConnectivityResult.wifi ||
          res == ConnectivityResult.ethernet) {
        if (widget.initialURI == null) {
          return Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ));
        } else {
          return Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RedirectedPage(initialURI: widget.initialURI),
              ));
        }
      } else {
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const ConnectionLostScreen()));
      }
    })
        //
        ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const Padding(
        padding: EdgeInsets.only(bottom: 100),
        child: SizedBox(
          height: 25,
          child: SpinKitWave(
            color: Colors.deepOrange,
            size: 25,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: SizedBox(
                width: 250,
                height: 250,
                child: Image.asset("assets/images/logo.png")),
          ),
        ),
      ),
    );
  }
}
