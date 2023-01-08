import 'package:dainik_ujala/Backend/api.dart';
import 'package:dainik_ujala/Views/detial_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Backend/models.dart';
import 'main_page.dart';

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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Page not found !!",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w100,
                              fontSize: 40,
                            )),
                    MaterialButton(
                      color: const Color(0xFF6371AA),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ));
                      },
                      child: SizedBox(
                        width: 120,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "go home".toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              CupertinoIcons.home,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
    );
  }
}
