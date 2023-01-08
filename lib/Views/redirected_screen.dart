import 'package:dainik_ujala/Backend/api.dart';
import 'package:dainik_ujala/Views/detial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Backend/models.dart';

class RedirectedPage extends StatefulWidget {
  const RedirectedPage({super.key, this.initialURI});
  final Uri? initialURI;
  @override
  State<RedirectedPage> createState() => _RedirectedPageState();
}

class _RedirectedPageState extends State<RedirectedPage> {
  bool notFound = false;

  getData() async {
    setState(() {
      notFound = false;
    });
    String url = widget.initialURI.toString();
    String slug = url.split("/")[3];
    Iterable<NewsArtical> data = await FetchData.callApi(page: 0, slug: slug);
    debugPrint("${data.length}");
    if (data.isNotEmpty) {
      //ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(data: data.elementAt(0)),
          ));

      debugPrint(data.elementAt(0).title);
    } else {
      setState(() {
        notFound = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: !notFound
              ? const SpinKitRotatingCircle(color: Colors.deepOrange, size: 75)
              : Text("Page not found !!",
                  style: Theme.of(context).textTheme.bodyMedium)),
    );
  }
}
