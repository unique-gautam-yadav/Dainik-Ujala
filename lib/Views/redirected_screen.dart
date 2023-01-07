import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RedirectedPage extends StatefulWidget {
  const RedirectedPage({super.key, this.initialURI});
  final Uri? initialURI;
  @override
  State<RedirectedPage> createState() => _RedirectedPageState();
}

class _RedirectedPageState extends State<RedirectedPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: SpinKitRotatingCircle(color: Colors.deepOrange, size: 75)),
    );
  }
}
