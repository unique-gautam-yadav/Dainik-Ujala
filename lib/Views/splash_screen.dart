import 'package:dainik_ujala/Views/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3))
            .then((value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                )))
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
